#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6520 "Item Tracing Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        FirstLevelEntries: Record "Item Tracing Buffer" temporary;
        TempTraceHistory: Record "Item Tracing History Buffer" temporary;
        SearchCriteria: Option "None",Lot,Serial,Both,Item;
        TempLineNo: Integer;
        CurrentLevel: Integer;
        NextLineNo: Integer;
        CurrentHistoryEntryNo: Integer;


    procedure FindRecords(var TempTrackEntry: Record "Item Tracing Buffer";var TempTrackEntry2: Record "Item Tracing Buffer";SerialNoFilter: Text;LotNoFilter: Text;ItemNoFilter: Text;VariantFilter: Text;Direction: Option Forward,Backward;ShowComponents: Option No,"Item-tracked only",All)
    begin
        DeleteTempTables(TempTrackEntry,TempTrackEntry2);
        InitSearchCriteria(SerialNoFilter,LotNoFilter,ItemNoFilter);
        FirstLevel(TempTrackEntry,SerialNoFilter,LotNoFilter,ItemNoFilter,VariantFilter,Direction,ShowComponents);
        if TempLineNo > 0 then
          InitTempTable(TempTrackEntry,TempTrackEntry2);
        TempTrackEntry.Reset;
        UpdateHistory(SerialNoFilter,LotNoFilter,ItemNoFilter,VariantFilter,Direction,ShowComponents);
    end;

    local procedure FirstLevel(var TempTrackEntry: Record "Item Tracing Buffer";SerialNoFilter: Text;LotNoFilter: Text;ItemNoFilter: Text;VariantFilter: Text;Direction: Option Forward,Backward;ShowComponents: Option No,"Item-tracked only",All)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemLedgEntry2: Record "Item Ledger Entry";
        ItemApplnEntry: Record "Item Application Entry";
    begin
        TempLineNo := 0;
        CurrentLevel := 0;

        ItemLedgEntry.Reset;
        case SearchCriteria of
          Searchcriteria::None:
            exit;
          Searchcriteria::Serial:
            if not ItemLedgEntry.SetCurrentkey("Serial No.") then
              if ItemNoFilter <> '' then
                ItemLedgEntry.SetCurrentkey("Item No.")
              else
                ItemLedgEntry.SetCurrentkey("Item No.",Open,"Variant Code",Positive,
                  "Location Code","Posting Date","Expiration Date","Lot No.","Serial No.");
          Searchcriteria::Lot,
          Searchcriteria::Both:
            if not ItemLedgEntry.SetCurrentkey("Lot No.") then
              if ItemNoFilter <> '' then
                ItemLedgEntry.SetCurrentkey("Item No.")
              else
                ItemLedgEntry.SetCurrentkey("Item No.",Open,"Variant Code",Positive,
                  "Location Code","Posting Date","Expiration Date","Lot No.","Serial No.");
          Searchcriteria::Item:
            ItemLedgEntry.SetCurrentkey("Item No.");
        end;

        ItemLedgEntry.SetFilter("Lot No.",LotNoFilter);
        ItemLedgEntry.SetFilter("Serial No.",SerialNoFilter);
        ItemLedgEntry.SetFilter("Item No.",ItemNoFilter);
        ItemLedgEntry.SetFilter("Variant Code",VariantFilter);
        if Direction = Direction::Forward then
          ItemLedgEntry.SetRange(Positive,true);

        Clear(FirstLevelEntries);
        FirstLevelEntries.DeleteAll;
        NextLineNo := 0;
        if ItemLedgEntry.FindSet then
          repeat
            NextLineNo += 1;
            FirstLevelEntries."Line No." := NextLineNo;
            FirstLevelEntries."Item No." := ItemLedgEntry."Item No.";
            FirstLevelEntries."Serial No." := ItemLedgEntry."Serial No.";
            FirstLevelEntries."Lot No." := ItemLedgEntry."Lot No.";
            FirstLevelEntries."Item Ledger Entry No." := ItemLedgEntry."Entry No.";
            FirstLevelEntries.Insert;
          until ItemLedgEntry.Next = 0;

        case SearchCriteria of
          Searchcriteria::None:
            exit;
          Searchcriteria::Serial:
            FirstLevelEntries.SetCurrentkey("Serial No.","Item Ledger Entry No.");
          Searchcriteria::Lot,
          Searchcriteria::Both:
            FirstLevelEntries.SetCurrentkey("Lot No.","Item Ledger Entry No.");
          Searchcriteria::Item:
            FirstLevelEntries.SetCurrentkey("Item No.","Item Ledger Entry No.");
        end;

        FirstLevelEntries.Ascending(Direction = Direction::Forward);
        if FirstLevelEntries.Find('-') then
          repeat
            ItemLedgEntry.Get(FirstLevelEntries."Item Ledger Entry No.");
            if ItemLedgEntry.TrackingExists then begin
              ItemLedgEntry2 := ItemLedgEntry;

              // Test for Reclass
              if (Direction = Direction::Backward) and
                 (ItemLedgEntry."Entry Type" = ItemLedgEntry."entry type"::Transfer) and
                 not ItemLedgEntry.Positive
              then begin
                ItemApplnEntry.Reset;
                ItemApplnEntry.SetCurrentkey("Outbound Item Entry No.");
                ItemApplnEntry.SetRange("Outbound Item Entry No.",ItemLedgEntry2."Entry No.");
                ItemApplnEntry.SetRange("Item Ledger Entry No.",ItemLedgEntry2."Entry No.");
                ItemApplnEntry.SetRange("Transferred-from Entry No.",0);
                if ItemApplnEntry.FindFirst then begin
                  ItemApplnEntry.SetFilter("Item Ledger Entry No.",'<>%1',ItemLedgEntry2."Entry No.");
                  ItemApplnEntry.SetRange("Transferred-from Entry No.",ItemApplnEntry."Inbound Item Entry No.");
                  if ItemApplnEntry.FindFirst then begin
                    ItemLedgEntry2.Reset;
                    if not ItemLedgEntry2.Get(ItemApplnEntry."Item Ledger Entry No.") then
                      ItemLedgEntry2 := ItemLedgEntry;
                  end;
                end;
              end;

              if SearchCriteria = Searchcriteria::Item then
                ItemLedgEntry2.SetRange("Item No.",ItemLedgEntry."Item No.");
              TransferData(ItemLedgEntry2,TempTrackEntry);
              if InsertRecord(TempTrackEntry,0) then begin
                FindComponents(ItemLedgEntry2,TempTrackEntry,Direction,ShowComponents,ItemLedgEntry2."Entry No.");
                NextLevel(TempTrackEntry,TempTrackEntry,Direction,ShowComponents,ItemLedgEntry2."Entry No.");
              end;
            end;
          until (FirstLevelEntries.Next = 0) or (CurrentLevel > 50);
    end;

    local procedure NextLevel(var TempTrackEntry: Record "Item Tracing Buffer";TempTrackEntry2: Record "Item Tracing Buffer";Direction: Option Forward,Backward;ShowComponents: Option No,"Item-tracked only",All;ParentID: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemApplnEntry: Record "Item Application Entry";
        TrackNo: Integer;
    begin
        with TempTrackEntry2 do begin
          if ExitLevel(TempTrackEntry) then
            exit;
          CurrentLevel += 1;

          ItemApplnEntry.Reset;
          // Test for if we have reached lowest level possible - if so exit
          if (Direction = Direction::Backward) and Positive then begin
            ItemApplnEntry.SetCurrentkey("Inbound Item Entry No.","Item Ledger Entry No.","Outbound Item Entry No.");
            ItemApplnEntry.SetRange("Inbound Item Entry No.","Item Ledger Entry No.");
            ItemApplnEntry.SetRange("Item Ledger Entry No.","Item Ledger Entry No.");
            ItemApplnEntry.SetRange("Outbound Item Entry No.",0);
            if ItemApplnEntry.Find('-') then begin
              CurrentLevel -= 1;
              exit;
            end;
            ItemApplnEntry.Reset;
          end;

          if Positive then begin
            ItemApplnEntry.SetCurrentkey("Inbound Item Entry No.","Item Ledger Entry No.","Outbound Item Entry No.");
            ItemApplnEntry.SetRange("Inbound Item Entry No.","Item Ledger Entry No.");
          end else begin
            ItemApplnEntry.SetCurrentkey("Outbound Item Entry No.");
            ItemApplnEntry.SetRange("Outbound Item Entry No.","Item Ledger Entry No.");
          end;

          if Direction = Direction::Forward then
            ItemApplnEntry.SetFilter("Item Ledger Entry No.",'<>%1',"Item Ledger Entry No.")
          else
            ItemApplnEntry.SetRange("Item Ledger Entry No.","Item Ledger Entry No.");

          ItemApplnEntry.Ascending(Direction = Direction::Forward);
          if ItemApplnEntry.Find('-') then
            repeat
              if Positive then
                TrackNo := ItemApplnEntry."Outbound Item Entry No."
              else
                TrackNo := ItemApplnEntry."Inbound Item Entry No.";

              if TrackNo <> 0 then
                if ItemLedgEntry.Get(TrackNo) then begin
                  TransferData(ItemLedgEntry,TempTrackEntry);
                  if InsertRecord(TempTrackEntry,ParentID) then begin
                    FindComponents(ItemLedgEntry,TempTrackEntry,Direction,ShowComponents,ItemLedgEntry."Entry No.");
                    NextLevel(TempTrackEntry,TempTrackEntry,Direction,ShowComponents,ItemLedgEntry."Entry No.");
                  end;
                end;
            until (TrackNo = 0) or (ItemApplnEntry.Next = 0);
        end;
        CurrentLevel -= 1;
    end;

    local procedure FindComponents(var ItemLedgEntry2: Record "Item Ledger Entry";var TempTrackEntry: Record "Item Tracing Buffer";Direction: Option Forward,Backward;ShowComponents: Option No,"Item-tracked only",All;ParentID: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        with ItemLedgEntry2 do begin
          if (("Order Type" <> "order type"::Production) and ("Order Type" <> "order type"::Assembly)) or ("Order No." = '') then
            exit;

          if ((("Entry Type" = "entry type"::Consumption) or ("Entry Type" = "entry type"::"Assembly Consumption")) and
              (Direction = Direction::Forward) ) or
             ((("Entry Type" = "entry type"::Output) or ("Entry Type" = "entry type"::"Assembly Output")) and
              (Direction = Direction::Backward))
          then begin
            ItemLedgEntry.Reset;
            ItemLedgEntry.SetCurrentkey("Order Type","Order No.");
            ItemLedgEntry.SetRange("Order Type","Order Type");
            ItemLedgEntry.SetRange("Order No.","Order No.");
            if "Order Type" = "order type"::Production then
              ItemLedgEntry.SetRange("Order Line No.","Order Line No.");
            ItemLedgEntry.SetFilter("Entry No.",'<>%1',ParentID);
            if ("Entry Type" = "entry type"::Consumption) or ("Entry Type" = "entry type"::"Assembly Consumption") then begin
              if ShowComponents <> Showcomponents::No then begin
                ItemLedgEntry.SetFilter("Entry Type",'%1|%2',ItemLedgEntry."entry type"::Consumption,
                  ItemLedgEntry."entry type"::"Assembly Consumption");
                ItemLedgEntry.SetRange(Positive,false);
                if ItemLedgEntry.Find('-') then
                  repeat
                    if (ShowComponents = Showcomponents::All) or ItemLedgEntry.TrackingExists then begin
                      CurrentLevel += 1;
                      TransferData(ItemLedgEntry,TempTrackEntry);
                      if InsertRecord(TempTrackEntry,ParentID) then
                        NextLevel(TempTrackEntry,TempTrackEntry,Direction,ShowComponents,ItemLedgEntry."Entry No.");
                      CurrentLevel -= 1;
                    end;
                  until ItemLedgEntry.Next = 0;
              end;
              ItemLedgEntry.SetFilter("Entry Type",'%1|%2',ItemLedgEntry."entry type"::Output,
                ItemLedgEntry."entry type"::"Assembly Output");
              ItemLedgEntry.SetRange(Positive,true);
            end else begin
              if ShowComponents = Showcomponents::No then
                exit;
              ItemLedgEntry.SetFilter("Entry Type",'%1|%2',ItemLedgEntry."entry type"::Consumption,
                ItemLedgEntry."entry type"::"Assembly Consumption");
              ItemLedgEntry.SetRange(Positive,false);
            end;
            CurrentLevel += 1;
            if ItemLedgEntry.Find('-') then
              repeat
                if (ShowComponents = Showcomponents::All) or ItemLedgEntry.TrackingExists then begin
                  TransferData(ItemLedgEntry,TempTrackEntry);
                  if InsertRecord(TempTrackEntry,ParentID) then
                    NextLevel(TempTrackEntry,TempTrackEntry,Direction,ShowComponents,ItemLedgEntry."Entry No.");
                end;
              until ItemLedgEntry.Next = 0;
            CurrentLevel -= 1;
          end;
        end;
    end;

    local procedure InsertRecord(var TempTrackEntry: Record "Item Tracing Buffer";ParentID: Integer): Boolean
    var
        TempTrackEntry2: Record "Item Tracing Buffer";
        ProductionOrder: Record "Production Order";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Job: Record Job;
        RecRef: RecordRef;
        InsertEntry: Boolean;
        Description2: Text[100];
    begin
        with TempTrackEntry do begin
          TempTrackEntry2 := TempTrackEntry;
          Reset;
          SetCurrentkey("Item Ledger Entry No.");
          SetRange("Item Ledger Entry No.","Item Ledger Entry No.");

          // Mark entry if already in search result
          TempTrackEntry2."Already Traced" := FindFirst;

          if CurrentLevel = 1 then begin
            SetRange("Parent Item Ledger Entry No.",ParentID);
            SetFilter(Level,'<>%1',CurrentLevel);
          end;

          InsertEntry := true;
          if CurrentLevel <= 1 then
            InsertEntry := not FindFirst;

          if InsertEntry then begin
            TempTrackEntry2.Reset;
            TempTrackEntry := TempTrackEntry2;
            TempLineNo += 1;
            "Line No." := TempLineNo;
            SetRecordID(TempTrackEntry);
            "Parent Item Ledger Entry No." := ParentID;
            if Format("Record Identifier") = '' then
              Description2 := StrSubstNo('%1 %2',"Entry Type","Document No.")
            else begin
              if RecRef.Get("Record Identifier") then
                case RecRef.Number of
                  Database::"Production Order":
                    begin
                      RecRef.SetTable(ProductionOrder);
                      Description2 :=
                        StrSubstNo('%1 %2 %3 %4',ProductionOrder.Status,RecRef.Caption,"Entry Type","Document No.");
                    end;
                  Database::"Posted Assembly Header":
                    Description2 := StrSubstNo('%1 %2',"Entry Type","Document No.");
                  Database::"Item Ledger Entry":
                    begin
                      RecRef.SetTable(ItemLedgerEntry);
                      if ItemLedgerEntry."Job No." <> '' then begin
                        Job.Get(ItemLedgerEntry."Job No.");
                        Description2 := Format(StrSubstNo('%1 %2',Job.TableCaption,ItemLedgerEntry."Job No."),-50);
                      end;
                    end;
                end;
              if Description2 = '' then
                Description2 := StrSubstNo('%1 %2',RecRef.Caption,"Document No.");
            end;
            SetDescription(Description2);
            Insert;
            exit(true);
          end;
          exit(false);
        end;
    end;


    procedure InitTempTable(var TempTrackEntry: Record "Item Tracing Buffer";var TempTrackEntry2: Record "Item Tracing Buffer")
    begin
        TempTrackEntry2.Reset;
        TempTrackEntry2.DeleteAll;
        TempTrackEntry.Reset;
        TempTrackEntry.SetRange(Level,0);
        if TempTrackEntry.Find('-') then
          repeat
            TempTrackEntry2 := TempTrackEntry;
            TempTrackEntry2.Insert;
          until TempTrackEntry.Next = 0;
    end;

    local procedure DeleteTempTables(var TempTrackEntry: Record "Item Tracing Buffer";var TempTrackEntry2: Record "Item Tracing Buffer")
    begin
        Clear(TempTrackEntry);
        if not TempTrackEntry.IsEmpty then
          TempTrackEntry.DeleteAll;

        Clear(TempTrackEntry2);
        if not TempTrackEntry2.IsEmpty then
          TempTrackEntry2.DeleteAll;
    end;


    procedure ExpandAll(var TempTrackEntry: Record "Item Tracing Buffer";var TempTrackEntry2: Record "Item Tracing Buffer")
    begin
        TempTrackEntry2.Reset;
        TempTrackEntry2.DeleteAll;
        TempTrackEntry.Reset;
        if TempTrackEntry.FindSet then
          repeat
            TempTrackEntry2 := TempTrackEntry;
            TempTrackEntry2.Insert;
          until TempTrackEntry.Next = 0;
    end;

    local procedure IsExpanded(ActualTrackingLine: Record "Item Tracing Buffer";var TempTrackEntry2: Record "Item Tracing Buffer"): Boolean
    var
        xTrackEntry: Record "Item Tracing Buffer";
        Found: Boolean;
    begin
        xTrackEntry.Copy(TempTrackEntry2);
        TempTrackEntry2.Reset;
        TempTrackEntry2 := ActualTrackingLine;
        Found := (TempTrackEntry2.Next <> 0);
        if Found then
          Found := (TempTrackEntry2.Level > ActualTrackingLine.Level);
        TempTrackEntry2.Copy(xTrackEntry);
        exit(Found);
    end;

    local procedure HasChildren(ActualTrackingLine: Record "Item Tracing Buffer";var TempTrackEntry: Record "Item Tracing Buffer"): Boolean
    begin
        TempTrackEntry.Reset;
        TempTrackEntry := ActualTrackingLine;
        if TempTrackEntry.Next = 0 then
          exit(false);

        exit(TempTrackEntry.Level > ActualTrackingLine.Level);
    end;

    local procedure TransferData(var ItemLedgEntry: Record "Item Ledger Entry";var TempTrackEntry: Record "Item Tracing Buffer")
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        ValueEntry: Record "Value Entry";
    begin
        TempTrackEntry.Init;
        TempTrackEntry."Line No." := 9999999;
        TempTrackEntry.Level := CurrentLevel;
        TempTrackEntry."Item No." := ItemLedgEntry."Item No.";
        TempTrackEntry."Item Description" := GetItemDescription(ItemLedgEntry."Item No.");
        TempTrackEntry."Posting Date" := ItemLedgEntry."Posting Date";
        TempTrackEntry."Entry Type" := ItemLedgEntry."Entry Type";
        TempTrackEntry."Source Type" := ItemLedgEntry."Source Type";
        TempTrackEntry."Source No." := ItemLedgEntry."Source No.";
        TempTrackEntry."Source Name" := '';
        case TempTrackEntry."Source Type" of
          TempTrackEntry."source type"::Customer:
            if Customer.Get(TempTrackEntry."Source No.") then
              TempTrackEntry."Source Name" := Customer.Name;
          TempTrackEntry."source type"::Vendor:
            if Vendor.Get(TempTrackEntry."Source No.") then
              TempTrackEntry."Source Name" := Vendor.Name;
        end;
        TempTrackEntry."Document No." := ItemLedgEntry."Document No.";
        TempTrackEntry.Description := ItemLedgEntry.Description;
        TempTrackEntry."Location Code" := ItemLedgEntry."Location Code";
        TempTrackEntry.Quantity := ItemLedgEntry.Quantity;
        TempTrackEntry."Remaining Quantity" := ItemLedgEntry."Remaining Quantity";
        TempTrackEntry.Open := ItemLedgEntry.Open;
        TempTrackEntry.Positive := ItemLedgEntry.Positive;
        TempTrackEntry."Variant Code" := ItemLedgEntry."Variant Code";
        TempTrackEntry."Serial No." := ItemLedgEntry."Serial No.";
        TempTrackEntry."Lot No." := ItemLedgEntry."Lot No.";
        TempTrackEntry."Item Ledger Entry No." := ItemLedgEntry."Entry No.";

        ValueEntry.Reset;
        ValueEntry.SetCurrentkey("Item Ledger Entry No.","Document No.");
        ValueEntry.SetRange("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
        if not ValueEntry.FindFirst then
          Clear(ValueEntry);
        TempTrackEntry."Created by" := ValueEntry."User ID";
        TempTrackEntry."Created on" := ValueEntry."Posting Date";
    end;


    procedure InitSearchCriteria(SerialNoFilter: Text;LotNoFilter: Text;ItemNoFilter: Text)
    begin
        if (SerialNoFilter = '') and (LotNoFilter = '') and (ItemNoFilter = '') then
          SearchCriteria := Searchcriteria::None
        else
          if LotNoFilter <> '' then begin
            if SerialNoFilter = '' then
              SearchCriteria := Searchcriteria::Lot
            else
              SearchCriteria := Searchcriteria::Both;
          end else
            if SerialNoFilter <> '' then
              SearchCriteria := Searchcriteria::Serial
            else
              if ItemNoFilter <> '' then
                SearchCriteria := Searchcriteria::Item;
    end;


    procedure InitSearchParm(var Rec: Record "Item Tracing Buffer";var SerialNoFilter: Text;var LotNoFilter: Text;var ItemNoFilter: Text;var VariantFilter: Text)
    var
        ItemTrackingEntry: Record "Item Tracing Buffer";
    begin
        with Rec do begin
          ItemTrackingEntry.SetRange("Serial No.","Serial No.");
          ItemTrackingEntry.SetRange("Lot No.","Lot No.");
          ItemTrackingEntry.SetRange("Item No.","Item No.");
          ItemTrackingEntry.SetRange("Variant Code","Variant Code");
          SerialNoFilter := ItemTrackingEntry.GetFilter("Serial No.");
          LotNoFilter := ItemTrackingEntry.GetFilter("Lot No.");
          ItemNoFilter := ItemTrackingEntry.GetFilter("Item No.");
          VariantFilter := ItemTrackingEntry.GetFilter("Variant Code");
        end;
    end;


    procedure SetRecordID(var TrackingEntry: Record "Item Tracing Buffer")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnShipHeader: Record "Return Shipment Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        TransShipHeader: Record "Transfer Shipment Header";
        TransRcptHeader: Record "Transfer Receipt Header";
        ProductionOrder: Record "Production Order";
        ServShptHeader: Record "Service Shipment Header";
        ServInvHeader: Record "Service Invoice Header";
        ServCrMemoHeader: Record "Service Cr.Memo Header";
        RecRef: RecordRef;
    begin
        with TrackingEntry do begin
          Clear(RecRef);

          case "Entry Type" of
            "entry type"::Purchase:
              if not Positive then begin
                if PurchCrMemoHeader.Get("Document No.") then begin
                  RecRef.GetTable(PurchCrMemoHeader);
                  "Record Identifier" := RecRef.RecordId;
                end else
                  if ReturnShipHeader.Get("Document No.") then begin
                    RecRef.GetTable(ReturnShipHeader);
                    "Record Identifier" := RecRef.RecordId;
                  end else
                    if ItemLedgEntry.Get("Item Ledger Entry No.") then begin
                      RecRef.GetTable(ItemLedgEntry);
                      "Record Identifier" := RecRef.RecordId;
                    end;
              end else
                if PurchRcptHeader.Get("Document No.") then begin
                  RecRef.GetTable(PurchRcptHeader);
                  "Record Identifier" := RecRef.RecordId;
                end else
                  if PurchInvHeader.Get("Document No.") then begin
                    RecRef.GetTable(PurchInvHeader);
                    "Record Identifier" := RecRef.RecordId;
                  end else
                    if ItemLedgEntry.Get("Item Ledger Entry No.") then begin
                      RecRef.GetTable(ItemLedgEntry);
                      "Record Identifier" := RecRef.RecordId;
                    end;
            "entry type"::Sale:
              if IsServiceDocument("Item Ledger Entry No.",ItemLedgEntry) then
                case ItemLedgEntry."Document Type" of
                  ItemLedgEntry."document type"::"Service Shipment":
                    if ServShptHeader.Get("Document No.") then begin
                      RecRef.GetTable(ServShptHeader);
                      "Record Identifier" := RecRef.RecordId;
                    end else
                      begin
                      RecRef.GetTable(ItemLedgEntry);
                      "Record Identifier" := RecRef.RecordId;
                    end;
                  ItemLedgEntry."document type"::"Service Invoice":
                    if ServInvHeader.Get("Document No.") then begin
                      RecRef.GetTable(ServInvHeader);
                      "Record Identifier" := RecRef.RecordId;
                    end else begin
                      RecRef.GetTable(ItemLedgEntry);
                      "Record Identifier" := RecRef.RecordId;
                    end;
                  ItemLedgEntry."document type"::"Service Credit Memo":
                    if ServCrMemoHeader.Get("Document No.") then begin
                      RecRef.GetTable(ServCrMemoHeader);
                      "Record Identifier" := RecRef.RecordId;
                    end else begin
                      RecRef.GetTable(ItemLedgEntry);
                      "Record Identifier" := RecRef.RecordId;
                    end;
                end
              else
                if Positive then begin
                  if SalesCrMemoHeader.Get("Document No.") then begin
                    RecRef.GetTable(SalesCrMemoHeader);
                    "Record Identifier" := RecRef.RecordId;
                  end else
                    if ReturnRcptHeader.Get("Document No.") then begin
                      RecRef.GetTable(ReturnRcptHeader);
                      "Record Identifier" := RecRef.RecordId;
                    end else
                      if ItemLedgEntry.Get("Item Ledger Entry No.") then begin
                        RecRef.GetTable(ItemLedgEntry);
                        "Record Identifier" := RecRef.RecordId;
                      end;
                end else
                  if SalesShptHeader.Get("Document No.") then begin
                    RecRef.GetTable(SalesShptHeader);
                    "Record Identifier" := RecRef.RecordId;
                  end else
                    if SalesInvHeader.Get("Document No.") then begin
                      RecRef.GetTable(SalesInvHeader);
                      "Record Identifier" := RecRef.RecordId;
                    end else
                      if ItemLedgEntry.Get("Item Ledger Entry No.") then begin
                        RecRef.GetTable(ItemLedgEntry);
                        "Record Identifier" := RecRef.RecordId;
                      end;
            "entry type"::"Positive Adjmt.",
            "entry type"::"Negative Adjmt.":
              if ItemLedgEntry.Get("Item Ledger Entry No.") then begin
                RecRef.GetTable(ItemLedgEntry);
                "Record Identifier" := RecRef.RecordId;
              end;
            "entry type"::Transfer:
              if TransShipHeader.Get("Document No.") then begin
                RecRef.GetTable(TransShipHeader);
                "Record Identifier" := RecRef.RecordId;
              end else
                if TransRcptHeader.Get("Document No.") then begin
                  RecRef.GetTable(TransRcptHeader);
                  "Record Identifier" := RecRef.RecordId;
                end else
                  if ItemLedgEntry.Get("Item Ledger Entry No.") then begin
                    RecRef.GetTable(ItemLedgEntry);
                    "Record Identifier" := RecRef.RecordId;
                  end;
            "entry type"::"Assembly Consumption",
            "entry type"::"Assembly Output":
              SetRecordIDAssembly(TrackingEntry);
            "entry type"::Consumption,
            "entry type"::Output:
              begin
                ProductionOrder.SetFilter(Status,'>=%1',ProductionOrder.Status::Released);
                ProductionOrder.SetRange("No.","Document No.");
                if ProductionOrder.FindFirst then begin
                  RecRef.GetTable(ProductionOrder);
                  "Record Identifier" := RecRef.RecordId;
                end;
              end;
          end;
        end;
    end;

    local procedure SetRecordIDAssembly(var ItemTracingBuffer: Record "Item Tracing Buffer")
    var
        PostedAssemblyHeader: Record "Posted Assembly Header";
        RecRef: RecordRef;
    begin
        with ItemTracingBuffer do
          if PostedAssemblyHeader.Get("Document No.") then begin
            RecRef.GetTable(PostedAssemblyHeader);
            "Record Identifier" := RecRef.RecordId;
          end;
    end;


    procedure ShowDocument(RecID: RecordID)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ServShptHeader: Record "Service Shipment Header";
        ServInvHeader: Record "Service Invoice Header";
        ServCrMemoHeader: Record "Service Cr.Memo Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        ReturnShipHeader: Record "Return Shipment Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        TransShipHeader: Record "Transfer Shipment Header";
        TransRcptHeader: Record "Transfer Receipt Header";
        ProductionOrder: Record "Production Order";
        PostedAssemblyHeader: Record "Posted Assembly Header";
        RecRef: RecordRef;
    begin
        if Format(RecID) = '' then
          exit;

        RecRef := RecID.GetRecord;

        case RecID.TableNo of
          Database::"Item Ledger Entry":
            begin
              RecRef.SetTable(ItemLedgEntry);
              Page.RunModal(Page::"Item Ledger Entries",ItemLedgEntry);
            end;
          Database::"Sales Shipment Header":
            begin
              RecRef.SetTable(SalesShptHeader);
              Page.RunModal(Page::"Posted Sales Shipment",SalesShptHeader);
            end;
          Database::"Sales Invoice Header":
            begin
              RecRef.SetTable(SalesInvHeader);
              Page.RunModal(Page::"Posted Sales Invoice",SalesInvHeader);
            end;
          Database::"Sales Cr.Memo Header":
            begin
              RecRef.SetTable(SalesCrMemoHeader);
              Page.RunModal(Page::"Posted Sales Credit Memo",SalesCrMemoHeader);
            end;
          Database::"Service Shipment Header":
            begin
              RecRef.SetTable(ServShptHeader);
              Page.RunModal(Page::"Posted Service Shipment",ServShptHeader);
            end;
          Database::"Service Invoice Header":
            begin
              RecRef.SetTable(ServInvHeader);
              Page.RunModal(Page::"Posted Service Invoice",ServInvHeader);
            end;
          Database::"Service Cr.Memo Header":
            begin
              RecRef.SetTable(ServCrMemoHeader);
              Page.RunModal(Page::"Posted Service Credit Memo",ServCrMemoHeader);
            end;
          Database::"Purch. Rcpt. Header":
            begin
              RecRef.SetTable(PurchRcptHeader);
              Page.RunModal(Page::"Posted Purchase Receipt",PurchRcptHeader);
            end;
          Database::"Purch. Inv. Header":
            begin
              RecRef.SetTable(PurchInvHeader);
              Page.RunModal(Page::"Posted Purchase Invoice",PurchInvHeader);
            end;
          Database::"Purch. Cr. Memo Hdr.":
            begin
              RecRef.SetTable(PurchCrMemoHeader);
              Page.RunModal(Page::"Posted Purchase Credit Memo",PurchCrMemoHeader);
            end;
          Database::"Return Shipment Header":
            begin
              RecRef.SetTable(ReturnShipHeader);
              Page.RunModal(Page::"Posted Return Shipment",ReturnShipHeader);
            end;
          Database::"Return Receipt Header":
            begin
              RecRef.SetTable(ReturnRcptHeader);
              Page.RunModal(Page::"Posted Return Receipt",ReturnRcptHeader);
            end;
          Database::"Transfer Shipment Header":
            begin
              RecRef.SetTable(TransShipHeader);
              Page.RunModal(Page::"Posted Transfer Shipment",TransShipHeader);
            end;
          Database::"Transfer Receipt Header":
            begin
              RecRef.SetTable(TransRcptHeader);
              Page.RunModal(Page::"Posted Transfer Receipt",TransRcptHeader);
            end;
          Database::"Posted Assembly Line",
          Database::"Posted Assembly Header":
            begin
              RecRef.SetTable(PostedAssemblyHeader);
              Page.RunModal(Page::"Posted Assembly Order",PostedAssemblyHeader);
            end;
          Database::"Production Order":
            begin
              RecRef.SetTable(ProductionOrder);
              if ProductionOrder.Status = ProductionOrder.Status::Released then
                Page.RunModal(Page::"Released Production Order",ProductionOrder)
              else
                if ProductionOrder.Status = ProductionOrder.Status::Finished then
                  Page.RunModal(Page::"Finished Production Order",ProductionOrder);
            end;
        end;
    end;


    procedure SetExpansionStatus(Rec: Record "Item Tracing Buffer";var TempTrackEntry: Record "Item Tracing Buffer";var TempTrackEntry2: Record "Item Tracing Buffer";var ActualExpansionStatus: Option "Has Children",Expanded,"No Children")
    begin
        if IsExpanded(Rec,TempTrackEntry2) then
          ActualExpansionStatus := Actualexpansionstatus::Expanded
        else
          if HasChildren(Rec,TempTrackEntry) then
            ActualExpansionStatus := Actualexpansionstatus::"Has Children"
          else
            ActualExpansionStatus := Actualexpansionstatus::"No Children";
    end;

    local procedure GetItem(var Item: Record Item;ItemNo: Code[20])
    begin
        if ItemNo <> Item."No." then
          if not Item.Get(ItemNo) then
            Clear(Item);
    end;

    local procedure GetItemDescription(ItemNo: Code[20]): Text[50]
    var
        Item: Record Item;
    begin
        GetItem(Item,ItemNo);
        exit(Item.Description);
    end;

    local procedure GetItemTrackingCode(var ItemTrackingCode: Record "Item Tracking Code";ItemNo: Code[20])
    var
        Item: Record Item;
    begin
        GetItem(Item,ItemNo);
        if Item."Item Tracking Code" <> '' then begin
          if not ItemTrackingCode.Get(Item."Item Tracking Code") then
            Clear(ItemTrackingCode);
        end else
          Clear(ItemTrackingCode);
    end;


    procedure SpecificTracking(ItemNo: Code[20];SerialNo: Code[20];LotNo: Code[20]): Boolean
    var
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        GetItemTrackingCode(ItemTrackingCode,ItemNo);
        if ((SerialNo <> '') and ItemTrackingCode."SN Specific Tracking") or
           ((LotNo <> '') and ItemTrackingCode."Lot Specific Tracking")
        then
          exit(true);

        exit(false);
    end;

    local procedure ExitLevel(TempTrackEntry: Record "Item Tracing Buffer"): Boolean
    begin
        with TempTrackEntry do begin
          if ("Serial No." = '') and ("Lot No." = '') then
            exit(true);
          if CurrentLevel > 50 then
            exit(true);
          if not SpecificTracking("Item No.","Serial No.","Lot No.") then
            exit(true);
          if "Already Traced" then
            exit(true);
        end;

        exit(false);
    end;

    local procedure UpdateHistory(SerialNoFilter: Text;LotNoFilter: Text;ItemNoFilter: Text;VariantFilter: Text;TraceMethod: Option "Origin->Usage","Usage->Origin";ShowComponents: Option No,"Item-tracked only",All) OK: Boolean
    var
        LevelCount: Integer;
    begin
        with TempTraceHistory do begin
          Reset;
          SetFilter("Entry No.",'>%1',CurrentHistoryEntryNo);
          DeleteAll;

          repeat
            Init;
            "Entry No." := CurrentHistoryEntryNo + 1;
            Level := LevelCount;

            "Serial No. Filter" := CopyStr(SerialNoFilter,1,MaxStrLen("Serial No. Filter"));
            "Lot No. Filter" := CopyStr(LotNoFilter,1,MaxStrLen("Lot No. Filter"));
            "Item No. Filter" := CopyStr(ItemNoFilter,1,MaxStrLen("Item No. Filter"));
            "Variant Filter" := CopyStr(VariantFilter,1,MaxStrLen("Variant Filter"));

            if Level = 0 then begin
              "Trace Method" := TraceMethod;
              "Show Components" := ShowComponents;
            end;
            Insert;

            LevelCount += 1;
            SerialNoFilter := DelStr(SerialNoFilter,1,MaxStrLen("Serial No. Filter"));
            LotNoFilter := DelStr(LotNoFilter,1,MaxStrLen("Lot No. Filter"));
            ItemNoFilter := DelStr(ItemNoFilter,1,MaxStrLen("Item No. Filter"));
            VariantFilter := DelStr(VariantFilter,1,MaxStrLen("Variant Filter"));
          until (SerialNoFilter = '') and (LotNoFilter = '') and (ItemNoFilter = '') and (VariantFilter = '');
          CurrentHistoryEntryNo := "Entry No.";
        end;
        OK := true;
    end;


    procedure RecallHistory(Steps: Integer;var TempTrackEntry: Record "Item Tracing Buffer";var TempTrackEntry2: Record "Item Tracing Buffer";var SerialNoFilter: Text;var LotNoFilter: Text;var ItemNoFilter: Text;var VariantFilter: Text;var TraceMethod: Option "Origin->Usage","Usage->Origin";var ShowComponents: Option No,"Item-tracked only",All): Boolean
    begin
        if not RetrieveHistoryData(CurrentHistoryEntryNo + Steps,
             SerialNoFilter,LotNoFilter,ItemNoFilter,VariantFilter,TraceMethod,ShowComponents)
        then
          exit(false);
        DeleteTempTables(TempTrackEntry,TempTrackEntry2);
        InitSearchCriteria(SerialNoFilter,LotNoFilter,ItemNoFilter);
        FirstLevel(TempTrackEntry,SerialNoFilter,LotNoFilter,ItemNoFilter,
          VariantFilter,TraceMethod,ShowComponents);
        if TempLineNo > 0 then
          InitTempTable(TempTrackEntry,TempTrackEntry2);
        TempTrackEntry.Reset;
        CurrentHistoryEntryNo := CurrentHistoryEntryNo + Steps;
        exit(true);
    end;

    local procedure RetrieveHistoryData(EntryNo: Integer;var SerialNoFilter: Text;var LotNoFilter: Text;var ItemNoFilter: Text;var VariantFilter: Text;var TraceMethod: Option "Origin->Usage","Usage->Origin";var ShowComponents: Option No,"Item-tracked only",All): Boolean
    begin
        with TempTraceHistory do begin
          Reset;
          SetCurrentkey("Entry No.",Level);
          SetRange("Entry No.",EntryNo);
          if not FindSet then
            exit(false);
          repeat
            if Level = 0 then begin
              SerialNoFilter := "Serial No. Filter";
              LotNoFilter := "Lot No. Filter";
              ItemNoFilter := "Item No. Filter";
              VariantFilter := "Variant Filter";
              TraceMethod := "Trace Method";
              ShowComponents := "Show Components";
            end else begin
              SerialNoFilter := SerialNoFilter + "Serial No. Filter";
              LotNoFilter := LotNoFilter + "Lot No. Filter";
              ItemNoFilter := ItemNoFilter + "Item No. Filter";
              VariantFilter := VariantFilter + "Variant Filter";
            end;
          until Next = 0;
          exit(true);
        end;
    end;


    procedure GetHistoryStatus(var PreviousExists: Boolean;var NextExists: Boolean)
    begin
        TempTraceHistory.Reset;
        TempTraceHistory.SetFilter("Entry No.",'>%1',CurrentHistoryEntryNo);
        NextExists := not TempTraceHistory.IsEmpty;
        TempTraceHistory.SetFilter("Entry No.",'<%1',CurrentHistoryEntryNo);
        PreviousExists := not TempTraceHistory.IsEmpty;
    end;

    local procedure IsServiceDocument(ItemLedgEntryNo: Integer;var ItemLedgEntry: Record "Item Ledger Entry"): Boolean
    begin
        with ItemLedgEntry do
          if Get(ItemLedgEntryNo) then
            if "Document Type" in [
                                   "document type"::"Service Shipment","document type"::"Service Invoice",
                                   "document type"::"Service Credit Memo"]
            then
              exit(true);
        exit(false);
    end;
}

