#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 21 "Item Jnl.-Check Line"
{
    TableNo = "Item Journal Line";

    trigger OnRun()
    begin
        GLSetup.Get;
        RunCheck(Rec);
    end;

    var
        Text000: label 'cannot be a closing date';
        Text001: label 'is not within your range of allowed posting dates';
        Text003: label 'must not be negative when %1 is %2';
        Text004: label 'must have the same value as %1';
        Text005: label 'must be %1 or %2 when %3 is %4';
        Text006: label 'must equal %1 - %2 when %3 is %4 and %5 is %6';
        Text007: label 'You cannot post these lines because you have not entered a quantity on one or more of the lines. ';
        DimCombBlockedErr: label 'The combination of dimensions used in item journal line %1, %2, %3 is blocked. %4.', Comment='%1 = Journal Template Name; %2 = Journal Batch Name; %3 = Line No.';
        DimCausedErr: label 'A dimension used in item journal line %1, %2, %3 has caused an error. %4.', Comment='%1 = Journal Template Name; %2 = Journal Batch Name; %3 = Line No.';
        Text011: label '%1 must not be equal to %2';
        Location: Record Location;
        InvtSetup: Record "Inventory Setup";
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemJnlLine2: Record "Item Journal Line";
        ItemJnlLine3: Record "Item Journal Line";
        ProdOrderLine: Record "Prod. Order Line";
        DimMgt: Codeunit DimensionManagement;
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        Text012: label 'Warehouse handling is required for %1 = %2, %3 = %4, %5 = %6.';
        CalledFromInvtPutawayPick: Boolean;
        CalledFromAdjustment: Boolean;
        UseInTransitLocationErr: label 'You can use In-Transit location %1 for transfer orders only.';


    procedure RunCheck(var ItemJnlLine: Record "Item Journal Line")
    var
        InvtPeriod: Record "Inventory Period";
        WorkCenter: Record "Work Center";
        Item: Record Item;
    begin
        with ItemJnlLine do begin
          if EmptyLine then begin
            if not IsValueEntryForDeletedItem then
              exit;
          end else
            if not OnlyStopTime then
              TestField("Item No.");

          if Item.Get("Item No.") then
            Item.TestField("Base Unit of Measure");

          TestField("Posting Date");
          TestField("Document No.");
          if "Posting Date" <> NormalDate("Posting Date") then
            FieldError("Posting Date",Text000);

          CheckAllowedPostingDate(ItemJnlLine);

          if not InvtPeriod.IsValidDate("Posting Date") then
            InvtPeriod.ShowError("Posting Date");

          if "Document Date" <> 0D then
            if "Document Date" <> NormalDate("Document Date") then
              FieldError("Document Date",Text000);

          TestField("Gen. Prod. Posting Group");

          if InvtSetup."Location Mandatory" and
             ("Value Entry Type" = "value entry type"::"Direct Cost") and
             (Quantity <> 0) and
             not Adjustment
          then begin
            if (Type <> Type::Resource) and (Item.Type = Item.Type::Inventory) then
              TestField("Location Code");
            if "Entry Type" = "entry type"::Transfer then
              TestField("New Location Code")
            else
              TestField("New Location Code",'');
          end;

          if (("Entry Type" <> "entry type"::Transfer) or ("Order Type" <> "order type"::Transfer)) and
             not Adjustment
          then begin
            CheckInTransitLocation("Location Code");
            CheckInTransitLocation("New Location Code");
          end;

          CheckBins(ItemJnlLine);

          if "Entry Type" in ["entry type"::"Positive Adjmt.","entry type"::"Negative Adjmt."] then
            TestField("Discount Amount",0);

          if "Entry Type" = "entry type"::Transfer then begin
            if ("Value Entry Type" = "value entry type"::"Direct Cost") and
               ("Item Charge No." = '') and
               not Adjustment
            then
              TestField(Amount,0);
            TestField("Discount Amount",0);
            if Quantity < 0 then
              FieldError(Quantity,StrSubstNo(Text003,FieldCaption("Entry Type"),"Entry Type"));
            if Quantity <> "Invoiced Quantity" then
              FieldError("Invoiced Quantity",StrSubstNo(Text004,FieldCaption(Quantity)));
          end;

          if not "Phys. Inventory" then begin
            if "Entry Type" = "entry type"::Output then begin
              if ("Output Quantity (Base)" = 0) and ("Scrap Quantity (Base)" = 0) and
                 TimeIsEmpty and ("Invoiced Qty. (Base)" = 0)
              then
                Error(Text007)
            end else begin
              if ("Quantity (Base)" = 0) and ("Invoiced Qty. (Base)" = 0) then
                Error(Text007);
            end;
            TestField("Qty. (Calculated)",0);
            TestField("Qty. (Phys. Inventory)",0);
          end else
            CheckPhysInventory(ItemJnlLine);

          if "Entry Type" <> "entry type"::Output then begin
            TestField("Run Time",0);
            TestField("Setup Time",0);
            TestField("Stop Time",0);
            TestField("Output Quantity",0);
            TestField("Scrap Quantity",0);
          end;

          if "Applies-from Entry" <> 0 then begin
            ItemLedgEntry.Get("Applies-from Entry");
            ItemLedgEntry.TestField("Item No.","Item No.");
            ItemLedgEntry.TestField("Variant Code","Variant Code");
            ItemLedgEntry.TestField(Positive,false);
            if "Applies-to Entry" = "Applies-from Entry" then
              Error(
                Text011,
                FieldCaption("Applies-to Entry"),
                FieldCaption("Applies-from Entry"));
          end;

          if ("Entry Type" in ["entry type"::Consumption,"entry type"::Output]) and
             not ("Value Entry Type" = "value entry type"::Revaluation) and
             not OnlyStopTime
          then begin
            TestField("Source No.");
            TestField("Order Type","order type"::Production);
            if ("Entry Type" = "entry type"::Output) and
               CheckFindProdOrderLine(ProdOrderLine,"Order No.","Order Line No.")
            then
              TestField("Item No.",ProdOrderLine."Item No.");
            if Subcontracting then begin
              WorkCenter.Get("Work Center No.");
              WorkCenter.TestField("Subcontractor No.");
            end;
            if not CalledFromInvtPutawayPick then
              CheckWarehouse(ItemJnlLine);
          end;

          if "Entry Type" = "entry type"::"Assembly Consumption" then
            CheckWarehouse(ItemJnlLine);

          if ("Value Entry Type" <> "value entry type"::"Direct Cost") or ("Item Charge No." <> '') then
            if "Inventory Value Per" = "inventory value per"::" " then
              TestField("Applies-to Entry");

          CheckDimensions(ItemJnlLine);
        end;

        OnAfterCheckItemJnlLine(ItemJnlLine);
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Clear(Location)
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;

    local procedure CheckFindProdOrderLine(var ProdOrderLine: Record "Prod. Order Line";ProdOrderNo: Code[20];LineNo: Integer): Boolean
    begin
        with ProdOrderLine do begin
          SetFilter(Status,'>=%1',Status::Released);
          SetRange("Prod. Order No.",ProdOrderNo);
          SetRange("Line No.",LineNo);
          exit(FindFirst);
        end;
    end;


    procedure SetCalledFromInvtPutawayPick(NewCalledFromInvtPutawayPick: Boolean)
    begin
        CalledFromInvtPutawayPick := NewCalledFromInvtPutawayPick;
    end;

    local procedure CheckWarehouse(ItemJnlLine: Record "Item Journal Line")
    var
        AssemblyLine: Record "Assembly Line";
        ReservationEntry: Record "Reservation Entry";
        ItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        ShowError: Boolean;
    begin
        if (ItemJnlLine.Quantity = 0) or
           (ItemJnlLine."Item Charge No." <> '') or
           (ItemJnlLine."Value Entry Type" in
            [ItemJnlLine."value entry type"::Revaluation,ItemJnlLine."value entry type"::Rounding]) or
           ItemJnlLine.Adjustment
        then
          exit;

        GetLocation(ItemJnlLine."Location Code");
        if Location."Directed Put-away and Pick" then
          exit;

        case ItemJnlLine."Entry Type" of
          ItemJnlLine."entry type"::Output:
            if WhseOrderHandlingReqd(ItemJnlLine,Location) then
              if ItemJnlLine."Applies-to Entry" = 0 then begin
                ReservEngineMgt.InitFilterAndSortingLookupFor(ReservationEntry,false);
                ItemJnlLineReserve.FilterReservFor(ReservationEntry,ItemJnlLine);
                ReservationEntry.SetRange("Serial No."); // Ignore Serial No
                ReservationEntry.SetRange("Lot No."); // Ignore Lot No
                if ReservationEntry.FindSet then
                  repeat
                    if ReservationEntry."Appl.-to Item Entry" = 0 then
                      ShowError := true;
                  until (ReservationEntry.Next = 0) or ShowError
                else
                  ShowError := ItemJnlLine.LastOutputOperation(ItemJnlLine);
              end;
          ItemJnlLine."entry type"::Consumption:
            if WhseOrderHandlingReqd(ItemJnlLine,Location) then
              if WhseValidateSourceLine.WhseLinesExist(
                   Database::"Prod. Order Component",
                   3,
                   ItemJnlLine."Order No.",
                   ItemJnlLine."Order Line No.",
                   ItemJnlLine."Prod. Order Comp. Line No.",
                   ItemJnlLine.Quantity)
              then
                ShowError := true;
          ItemJnlLine."entry type"::"Assembly Consumption":
            if WhseOrderHandlingReqd(ItemJnlLine,Location) then
              if WhseValidateSourceLine.WhseLinesExist(
                   Database::"Assembly Line",
                   AssemblyLine."document type"::Order,
                   ItemJnlLine."Order No.",
                   ItemJnlLine."Order Line No.",
                   0,
                   ItemJnlLine.Quantity)
              then
                ShowError := true;
        end;
        if ShowError then
          Error(
            Text012,
            ItemJnlLine.FieldCaption("Entry Type"),
            ItemJnlLine."Entry Type",
            ItemJnlLine.FieldCaption("Order No."),
            ItemJnlLine."Order No.",
            ItemJnlLine.FieldCaption("Order Line No."),
            ItemJnlLine."Order Line No.");
    end;

    local procedure WhseOrderHandlingReqd(ItemJnlLine: Record "Item Journal Line";Location: Record Location): Boolean
    var
        InvtPutAwayLocation: Boolean;
        InvtPickLocation: Boolean;
    begin
        InvtPutAwayLocation := not Location."Require Receive" and Location."Require Put-away";
        if InvtPutAwayLocation then
          case ItemJnlLine."Entry Type" of
            ItemJnlLine."entry type"::Output:
              if ItemJnlLine.Quantity >= 0 then
                exit(true);
            ItemJnlLine."entry type"::Consumption,
            ItemJnlLine."entry type"::"Assembly Consumption":
              if ItemJnlLine.Quantity < 0 then
                exit(true);
          end;

        InvtPickLocation := not Location."Require Shipment" and Location."Require Pick" ;
        if InvtPickLocation then
          case ItemJnlLine."Entry Type" of
            ItemJnlLine."entry type"::Output:
              if ItemJnlLine.Quantity < 0 then
                exit(true);
            ItemJnlLine."entry type"::Consumption,
            ItemJnlLine."entry type"::"Assembly Consumption":
              if ItemJnlLine.Quantity >= 0 then
                exit(true);
          end;

        exit(false);
    end;

    local procedure CheckAllowedPostingDate(ItemJnlLine: Record "Item Journal Line")
    begin
        with ItemJnlLine do begin
          if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
            InvtSetup.Get;
            GLSetup.Get;
            if UserId <> '' then
              if UserSetup.Get(UserId) then begin
                AllowPostingFrom := UserSetup."Allow Posting From";
                AllowPostingTo := UserSetup."Allow Posting To";
              end;
            if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
              AllowPostingFrom := GLSetup."Allow Posting From";
              AllowPostingTo := GLSetup."Allow Posting To";
            end;
            if AllowPostingTo = 0D then
              AllowPostingTo := Dmy2date(31,12,9999);
          end;
          if ("Posting Date" < AllowPostingFrom) or ("Posting Date" > AllowPostingTo) then
            FieldError("Posting Date",Text001)
        end;
    end;


    procedure SetCalledFromAdjustment(NewCalledFromAdjustment: Boolean)
    begin
        CalledFromAdjustment := NewCalledFromAdjustment;
    end;

    local procedure CheckBins(ItemJnlLine: Record "Item Journal Line")
    var
        WMSManagement: Codeunit "WMS Management";
    begin
        with ItemJnlLine do begin
          if ("Item Charge No." <> '') or ("Value Entry Type" <> "value entry type"::"Direct Cost") or (Quantity = 0) then
            exit;

          if "Entry Type" = "entry type"::Transfer then begin
            GetLocation("New Location Code");
            if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then
              TestField("New Bin Code");
          end;

          if "Drop Shipment" or OnlyStopTime or ("Quantity (Base)" = 0) or Adjustment or CalledFromAdjustment then
            exit;

          GetLocation("Location Code");
          if not Location."Bin Mandatory" or Location."Directed Put-away and Pick" then
            exit;

          if ("Entry Type" = "entry type"::Output) and not LastOutputOperation(ItemJnlLine) then
            exit;

          if Quantity <> 0 then
            case "Entry Type" of
              "entry type"::Purchase,
              "entry type"::"Positive Adjmt.",
              "entry type"::Output,
              "entry type"::"Assembly Output":
                WMSManagement.CheckInbOutbBin("Location Code","Bin Code",Quantity > 0);
              "entry type"::Sale,
              "entry type"::"Negative Adjmt.",
              "entry type"::Consumption,
              "entry type"::"Assembly Consumption":
                WMSManagement.CheckInbOutbBin("Location Code","Bin Code",Quantity < 0);
              "entry type"::Transfer:
                begin
                  WMSManagement.CheckInbOutbBin("Location Code","Bin Code",Quantity < 0);
                  if ("New Location Code" <> '') and ("New Bin Code" <> '') then
                    WMSManagement.CheckInbOutbBin("New Location Code","New Bin Code",Quantity > 0);
                end;
            end;
        end;
    end;

    local procedure CheckDimensions(ItemJnlLine: Record "Item Journal Line")
    var
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        with ItemJnlLine do
          if not IsValueEntryForDeletedItem and not Correction and not CalledFromAdjustment then begin
            if not DimMgt.CheckDimIDComb("Dimension Set ID") then
              Error(DimCombBlockedErr,"Journal Template Name","Journal Batch Name","Line No.",DimMgt.GetDimCombErr);

            TableID[1] := Database::Item;
            No[1] := "Item No.";
            TableID[2] := Database::"Salesperson/Purchaser";
            No[2] := "Salespers./Purch. Code";
            TableID[3] := Database::"Work Center";
            No[3] := "Work Center No.";
            if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then begin
              if "Line No." <> 0 then
                Error(DimCausedErr,"Journal Template Name","Journal Batch Name","Line No.",DimMgt.GetDimValuePostingErr);
              Error(DimMgt.GetDimValuePostingErr);
            end;
            if ("Entry Type" = "entry type"::Transfer) and
               ("Value Entry Type" <> "value entry type"::Revaluation)
            then
              if not DimMgt.CheckDimIDComb("Dimension Set ID") then begin
                if "Line No." <> 0 then
                  Error(DimCausedErr,"Journal Template Name","Journal Batch Name","Line No.",DimMgt.GetDimValuePostingErr);
                Error(DimMgt.GetDimValuePostingErr);
              end;
          end;
    end;

    local procedure CheckPhysInventory(ItemJnlLine: Record "Item Journal Line")
    begin
        with ItemJnlLine do begin
          if not
             ("Entry Type" in
              ["entry type"::"Positive Adjmt.","entry type"::"Negative Adjmt."])
          then begin
            ItemJnlLine2."Entry Type" := ItemJnlLine2."entry type"::"Positive Adjmt.";
            ItemJnlLine3."Entry Type" := ItemJnlLine3."entry type"::"Negative Adjmt.";
            FieldError(
              "Entry Type",
              StrSubstNo(
                Text005,ItemJnlLine2."Entry Type",ItemJnlLine3."Entry Type",FieldCaption("Phys. Inventory"),true));
          end;
          if ("Entry Type" = "entry type"::"Positive Adjmt.") and
             ("Qty. (Phys. Inventory)" - "Qty. (Calculated)" <> Quantity)
          then
            FieldError(
              Quantity,
              StrSubstNo(
                Text006,FieldCaption("Qty. (Phys. Inventory)"),FieldCaption("Qty. (Calculated)"),
                FieldCaption("Entry Type"),"Entry Type",FieldCaption("Phys. Inventory"),true));
          if ("Entry Type" = "entry type"::"Negative Adjmt.") and
             ("Qty. (Calculated)" - "Qty. (Phys. Inventory)" <> Quantity)
          then
            FieldError(
              Quantity,
              StrSubstNo(
                Text006,FieldCaption("Qty. (Calculated)"),FieldCaption("Qty. (Phys. Inventory)"),
                FieldCaption("Entry Type"),"Entry Type",FieldCaption("Phys. Inventory"),true));
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckItemJnlLine(var ItemJnlLine: Record "Item Journal Line")
    begin
    end;

    local procedure CheckInTransitLocation(LocationCode: Code[10])
    begin
        if Location.IsInTransit(LocationCode) then
          Error(UseInTransitLocationErr,LocationCode)
    end;
}

