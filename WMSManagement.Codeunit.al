#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7302 "WMS Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'must not be %1';
        Text002: label '\Do you still want to use this %1 ?';
        Text003: label 'You must set-up a default location code for user %1.';
        Text004: label '%1 to place (%2) exceeds the available capacity (%3) on %4 %5.';
        Text005: label '%1 = ''%2'', %3 = ''%4'':\The total base quantity to take %5 must be equal to the total base quantity to place %6.';
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        Location: Record Location;
        Bin: Record Bin;
        TempErrorLog: Record "License Information" temporary;
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        WhseMgt: Codeunit "Whse. Management";
        ShowError: Boolean;
        NextLineNo: Integer;
        LogErrors: Boolean;
        Text006: label 'You must enter a %1 in %2 %3 = %4, %5 = %6.';
        Text007: label 'Canceled.';
        Text008: label 'Destination Name';
        Text009: label 'Sales Order';
        Text010: label 'You cannot change the %1 because this item journal line is created from warehouse entries.\%2 %3 is set up with %4 and therefore changes must be made in a %5. ';
        Text011: label 'You cannot use %1 %2 because it is set up with %3.\Adjustments to this location must therefore be made in a %4.';
        Text012: label 'You cannot reclassify %1 %2 because it is set up with %3.\You can change this location code by creating a %4.';
        Text013: label 'You cannot change item tracking because it is created from warehouse entries.\The %1 is set up with warehouse tracking, and %2 %3 is set up with %4.\Adjustments to item tracking must therefore be made in a warehouse journal.';
        Text014: label 'You cannot change item tracking because the %1 is set up with warehouse tracking and %2 %3 is set up with %4.\Adjustments to item tracking must therefore be made in a warehouse journal.';
        Text015: label 'You cannot use a %1 because %2 %3 is set up with %4.';
        Text016: label '%1 = ''%2'', %3 = ''%4'', %5 = ''%6'', %7 = ''%8'': The total base quantity to take %9 must be equal to the total base quantity to place %10.';
        UserIsNotWhseEmployeeErr: label 'You must first set up user %1 as a warehouse employee.';


    procedure CreateWhseJnlLine(ItemJnlLine: Record "Item Journal Line";ItemJnlTemplateType: Option;var WhseJnlLine: Record "Warehouse Journal Line";ToTransfer: Boolean): Boolean
    begin
        with ItemJnlLine do begin
          if ((not "Phys. Inventory") and (Quantity = 0) and ("Invoiced Quantity" = 0)) or
             ("Value Entry Type" in ["value entry type"::Rounding,"value entry type"::Revaluation]) or
             Adjustment
          then
            exit(false);

          if ToTransfer then
            "Location Code" := "New Location Code";
          GetLocation("Location Code");

          WhseJnlLine.Init;
          WhseJnlLine."Journal Template Name" := "Journal Template Name";
          WhseJnlLine."Journal Batch Name" := "Journal Batch Name";
          WhseJnlLine."Location Code" := "Location Code";
          WhseJnlLine."Item No." := "Item No.";
          WhseJnlLine."Registering Date" := "Posting Date";
          WhseJnlLine."User ID" := UserId;
          WhseJnlLine."Variant Code" := "Variant Code";
          if (("Entry Type" in
               ["entry type"::Purchase,"entry type"::"Positive Adjmt.","entry type"::"Assembly Output"]) and
              (Quantity > 0)) or
             (("Entry Type" in
               ["entry type"::Sale,"entry type"::"Negative Adjmt.","entry type"::"Assembly Consumption"]) and
              (Quantity < 0)) or
             ToTransfer
          then begin
            if "Entry Type" = "entry type"::Transfer then
              WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::Movement
            else
              WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::"Positive Adjmt.";
            if Location."Directed Put-away and Pick" then
              if "Entry Type" in ["entry type"::"Assembly Output","entry type"::"Assembly Consumption"] then
                WhseJnlLine."To Bin Code" := "Bin Code"
              else
                WhseJnlLine."To Bin Code" := GetWhseJnlLineBinCode("Source Code","Bin Code",Location."Adjustment Bin Code")
            else
              if ToTransfer then
                WhseJnlLine."To Bin Code" := "New Bin Code"
              else
                WhseJnlLine."To Bin Code" := "Bin Code";
            GetBin("Location Code",WhseJnlLine."To Bin Code");
            WhseJnlLine."To Zone Code" := Bin."Zone Code";
          end else
            if (("Entry Type" in
                 ["entry type"::Purchase,"entry type"::"Positive Adjmt.","entry type"::"Assembly Output"]) and
                (Quantity < 0)) or
               (("Entry Type" in
                 ["entry type"::Sale,"entry type"::"Negative Adjmt.","entry type"::"Assembly Consumption"]) and
                (Quantity > 0)) or
               (("Entry Type" = "entry type"::Transfer) and (not ToTransfer))
            then begin
              if "Entry Type" = "entry type"::Transfer then
                WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::Movement
              else
                WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::"Negative Adjmt.";
              if Location."Directed Put-away and Pick" then
                if "Entry Type" in ["entry type"::"Assembly Output","entry type"::"Assembly Consumption"] then
                  WhseJnlLine."From Bin Code" := "Bin Code"
                else
                  WhseJnlLine."From Bin Code" := GetWhseJnlLineBinCode("Source Code","Bin Code",Location."Adjustment Bin Code")
              else
                WhseJnlLine."From Bin Code" := "Bin Code";
              if Location."Directed Put-away and Pick" then begin
                GetBin("Location Code",WhseJnlLine."From Bin Code");
                WhseJnlLine."From Zone Code" := Bin."Zone Code";
                WhseJnlLine."From Bin Type Code" := Bin."Bin Type Code";
              end;
            end else
              if "Phys. Inventory" and (Quantity = 0) and ("Invoiced Quantity" = 0) then begin
                WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::"Positive Adjmt.";
                if Location."Directed Put-away and Pick" then
                  WhseJnlLine."To Bin Code" := Location."Adjustment Bin Code"
                else
                  WhseJnlLine."To Bin Code" := "Bin Code";
                GetBin("Location Code",WhseJnlLine."To Bin Code");
                WhseJnlLine."To Zone Code" := Bin."Zone Code";
              end;
          if Location."Directed Put-away and Pick" then begin
            WhseJnlLine.Quantity := ROUND("Quantity (Base)" / "Qty. per Unit of Measure",0.00001);
            WhseJnlLine."Unit of Measure Code" := "Unit of Measure Code";
            WhseJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          end else begin
            WhseJnlLine.Quantity := "Quantity (Base)";
            WhseJnlLine."Unit of Measure Code" := GetBaseUOM("Item No.");
            WhseJnlLine."Qty. per Unit of Measure" := 1;
          end;
          WhseJnlLine."Qty. (Base)" := "Quantity (Base)";
          WhseJnlLine."Qty. (Absolute)" := Abs(WhseJnlLine.Quantity);
          WhseJnlLine."Qty. (Absolute, Base)" := Abs("Quantity (Base)");
          if ("Journal Template Name" <> '') and ("Journal Batch Name" <> '') then begin
            WhseJnlLine."Source Type" := Database::"Item Journal Line";
            WhseJnlLine."Source Subtype" := ItemJnlTemplateType;
            WhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(WhseJnlLine."Source Type",WhseJnlLine."Source Subtype");
            WhseJnlLine."Source No." := "Document No.";
            WhseJnlLine."Source Line No." := "Line No.";
          end else
            if "Job No." <> '' then begin
              WhseJnlLine."Source Type" := Database::"Job Journal Line";
              WhseJnlLine."Source Subtype" := ItemJnlTemplateType;
              WhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(WhseJnlLine."Source Type",WhseJnlLine."Source Subtype");
              WhseJnlLine."Source No." := "Document No.";
              WhseJnlLine."Source Line No." := "Line No.";
            end;
          WhseJnlLine."Source Code" := "Source Code";
          WhseJnlLine."Reason Code" := "Reason Code";
          WhseJnlLine."Registering No. Series" := "Posting No. Series";
          WhseJnlLine."Whse. Document Type" := WhseJnlLine."whse. document type"::" ";
          if "Job No." = '' then
            WhseJnlLine."Reference Document" := WhseJnlLine."reference document"::"Item Journal"
          else
            WhseJnlLine."Reference Document" := WhseJnlLine."reference document"::"Job Journal";
          WhseJnlLine."Reference No." := "Document No.";
          if Location."Directed Put-away and Pick" then
            CalcCubageAndWeight(
              "Item No.","Unit of Measure Code",WhseJnlLine."Qty. (Absolute)",
              WhseJnlLine.Cubage,WhseJnlLine.Weight);
          WhseJnlLine."Registering No. Series" := "Posting No. Series";
          TransferWhseItemTrkg(WhseJnlLine,ItemJnlLine);
          WhseJnlLine.Description := Description;
          exit(true);
        end;
    end;


    procedure CreateWhseJnlLineFromOutputJnl(ItemJnlLine: Record "Item Journal Line";var WhseJnlLine: Record "Warehouse Journal Line"): Boolean
    begin
        with ItemJnlLine do begin
          if Adjustment or
             ("Value Entry Type" in ["value entry type"::Rounding,"value entry type"::Revaluation])
          then
            exit(false);

          GetLocation("Location Code");
          WhseJnlLine.Init;
          WhseJnlLine."Journal Template Name" := "Journal Template Name";
          WhseJnlLine."Journal Batch Name" := "Journal Batch Name";
          WhseJnlLine."Location Code" := "Location Code";
          WhseJnlLine."Item No." := "Item No.";
          WhseJnlLine."Registering Date" := "Posting Date";
          WhseJnlLine."User ID" := UserId;
          WhseJnlLine."Variant Code" := "Variant Code";
          if "Output Quantity" >= 0 then begin
            WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::"Positive Adjmt.";
            WhseJnlLine."To Bin Code" := "Bin Code";
            if Location."Directed Put-away and Pick" then begin
              GetBin("Location Code",WhseJnlLine."To Bin Code");
              WhseJnlLine."To Zone Code" := Bin."Zone Code";
            end;
          end else begin
            WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::"Negative Adjmt.";
            WhseJnlLine."From Bin Code" := "Bin Code";
            if Location."Directed Put-away and Pick" then begin
              GetBin("Location Code",WhseJnlLine."From Bin Code");
              WhseJnlLine."From Zone Code" := Bin."Zone Code";
            end;
          end;
          if "Qty. per Unit of Measure" = 0 then
            "Qty. per Unit of Measure" := 1;
          if Location."Directed Put-away and Pick" then begin
            WhseJnlLine.Quantity := ROUND("Output Quantity (Base)" / "Qty. per Unit of Measure",0.00001);
            WhseJnlLine."Unit of Measure Code" := "Unit of Measure Code";
            WhseJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          end else begin
            WhseJnlLine.Quantity := "Output Quantity (Base)";
            WhseJnlLine."Unit of Measure Code" := GetBaseUOM("Item No.");
            WhseJnlLine."Qty. per Unit of Measure" := 1;
          end;
          WhseJnlLine."Qty. (Base)" := "Output Quantity (Base)";
          WhseJnlLine."Qty. (Absolute)" := Abs(WhseJnlLine.Quantity);
          WhseJnlLine."Qty. (Absolute, Base)" := Abs("Output Quantity (Base)");

          WhseJnlLine."Source Type" := Database::"Item Journal Line";
          WhseJnlLine."Source Subtype" := 5; // Output Journal
          WhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(WhseJnlLine."Source Type",WhseJnlLine."Source Subtype");
          TestField("Order Type","order type"::Production);
          WhseJnlLine."Source No." := "Order No.";
          WhseJnlLine."Source Line No." := "Order Line No.";
          WhseJnlLine."Source Code" := "Source Code";
          WhseJnlLine."Reason Code" := "Reason Code";
          WhseJnlLine."Registering No. Series" := "Posting No. Series";
          WhseJnlLine."Whse. Document Type" := WhseJnlLine."whse. document type"::Production;
          WhseJnlLine."Whse. Document No." := "Order No.";
          WhseJnlLine."Whse. Document Line No." := "Order Line No.";
          WhseJnlLine."Reference Document" := WhseJnlLine."reference document"::"Prod.";
          WhseJnlLine."Reference No." := "Order No.";
          if Location."Directed Put-away and Pick" then
            CalcCubageAndWeight(
              "Item No.","Unit of Measure Code",WhseJnlLine."Qty. (Absolute)",
              WhseJnlLine.Cubage,WhseJnlLine.Weight);
          TransferWhseItemTrkg(WhseJnlLine,ItemJnlLine);
        end;
    end;


    procedure CreateWhseJnlLineFromConsumJnl(ItemJnlLine: Record "Item Journal Line";var WhseJnlLine: Record "Warehouse Journal Line"): Boolean
    var
        ProdOrderCompLine: Record "Prod. Order Component";
        SourceLineFound: Boolean;
    begin
        with ItemJnlLine do begin
          if Adjustment or
             ("Value Entry Type" in ["value entry type"::Rounding,"value entry type"::Revaluation])
          then
            exit(false);

          GetLocation("Location Code");
          WhseJnlLine.Init;
          WhseJnlLine."Journal Template Name" := "Journal Template Name";
          WhseJnlLine."Journal Batch Name" := "Journal Batch Name";
          WhseJnlLine."Location Code" := "Location Code";
          WhseJnlLine."Item No." := "Item No.";
          WhseJnlLine."Registering Date" := "Posting Date";
          WhseJnlLine."User ID" := UserId;
          WhseJnlLine."Variant Code" := "Variant Code";
          TestField("Order Type","order type"::Production);
          SourceLineFound := GetProdOrderCompLine(ProdOrderCompLine,ProdOrderCompLine.Status::Released,
              "Order No.","Order Line No.","Prod. Order Comp. Line No.");
          if SourceLineFound then begin
            if Quantity > 0 then begin
              WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::"Negative Adjmt.";
              WhseJnlLine."From Bin Code" := "Bin Code";
              if Location."Bin Mandatory" and Location."Require Pick" and Location."Require Shipment" then begin
                if (ProdOrderCompLine."Planning Level Code" = 0) and
                   ((ProdOrderCompLine."Flushing Method" = ProdOrderCompLine."flushing method"::Manual) or
                    (ProdOrderCompLine."Flushing Method" = ProdOrderCompLine."flushing method"::"Pick + Backward") or
                    ((ProdOrderCompLine."Flushing Method" = ProdOrderCompLine."flushing method"::"Pick + Forward") and
                     (ProdOrderCompLine."Routing Link Code" <> '')))
                then
                  if ProdOrderCompLine."Qty. Picked (Base)" < "Quantity (Base)" then
                    ProdOrderCompLine.FieldError("Qty. Picked (Base)");
                GetBin("Location Code",WhseJnlLine."From Bin Code");
                WhseJnlLine."From Zone Code" := Bin."Zone Code";
                WhseJnlLine."From Bin Type Code" := Bin."Bin Type Code";
              end;
            end else begin
              WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::"Positive Adjmt.";
              WhseJnlLine."To Bin Code" := "Bin Code";
              if Location."Directed Put-away and Pick" then begin
                GetBin("Location Code",WhseJnlLine."To Bin Code");
                WhseJnlLine."To Zone Code" := Bin."Zone Code";
              end;
            end;
          end else
            if Quantity > 0 then begin
              WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::"Negative Adjmt.";
              WhseJnlLine."From Bin Code" := "Bin Code";
              if Location."Directed Put-away and Pick" then begin
                GetBin("Location Code",WhseJnlLine."From Bin Code");
                WhseJnlLine."From Zone Code" := Bin."Zone Code";
                WhseJnlLine."From Bin Type Code" := Bin."Bin Type Code";
              end;
            end else begin
              WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::"Positive Adjmt.";
              WhseJnlLine."To Bin Code" := "Bin Code";
              if Location."Directed Put-away and Pick" then begin
                GetBin("Location Code",WhseJnlLine."To Bin Code");
                WhseJnlLine."To Zone Code" := Bin."Zone Code";
              end;
            end;
          if Location."Directed Put-away and Pick" then begin
            WhseJnlLine.Quantity := ROUND("Quantity (Base)" / "Qty. per Unit of Measure",0.00001);
            WhseJnlLine."Unit of Measure Code" := "Unit of Measure Code";
            WhseJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          end else begin
            WhseJnlLine.Quantity := "Quantity (Base)";
            WhseJnlLine."Unit of Measure Code" := GetBaseUOM("Item No.");
            WhseJnlLine."Qty. per Unit of Measure" := 1;
          end;
          WhseJnlLine."Qty. (Base)" := "Quantity (Base)";
          WhseJnlLine."Qty. (Absolute)" := Abs(WhseJnlLine.Quantity);
          WhseJnlLine."Qty. (Absolute, Base)" := Abs("Quantity (Base)");
          WhseJnlLine."Source Type" := Database::"Item Journal Line";
          WhseJnlLine."Source Subtype" := 4; // Consumption Journal
          WhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(WhseJnlLine."Source Type",WhseJnlLine."Source Subtype");
          WhseJnlLine."Source No." := "Order No.";
          WhseJnlLine."Source Line No." := "Order Line No.";
          WhseJnlLine."Source Subline No." := "Prod. Order Comp. Line No.";
          WhseJnlLine."Source Code" := "Source Code";
          WhseJnlLine."Reason Code" := "Reason Code";
          WhseJnlLine."Registering No. Series" := "Posting No. Series";
          WhseJnlLine."Whse. Document Type" := WhseJnlLine."whse. document type"::Production;
          WhseJnlLine."Whse. Document No." := "Order No.";
          WhseJnlLine."Whse. Document Line No." := "Order Line No.";
          WhseJnlLine."Reference Document" := WhseJnlLine."reference document"::"Prod.";
          WhseJnlLine."Reference No." := "Order No.";
          if Location."Directed Put-away and Pick" then
            CalcCubageAndWeight(
              "Item No.","Unit of Measure Code",WhseJnlLine."Qty. (Absolute)",
              WhseJnlLine.Cubage,WhseJnlLine.Weight);
          TransferWhseItemTrkg(WhseJnlLine,ItemJnlLine);
        end;
    end;


    procedure CheckWhseJnlLine(var WhseJnlLine: Record "Warehouse Journal Line";SourceJnl: Option " ",ItemJnl,OutputJnl,ConsumpJnl,WhseJnl;DecreaseQtyBase: Decimal;ToTransfer: Boolean)
    var
        BinContent: Record "Bin Content";
        ItemTrackingCode: Record "Item Tracking Code";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        QtyAbsBase: Decimal;
        WhseSNRequired: Boolean;
        WhseLNRequired: Boolean;
    begin
        GetItem(WhseJnlLine."Item No.");
        with WhseJnlLine do begin
          TestField("Location Code");
          GetLocation("Location Code");

          if SourceJnl = Sourcejnl::WhseJnl then
            CheckAdjBinCode(WhseJnlLine);

          if ItemTrackingCode.Get(Item."Item Tracking Code") then begin
            if ("Serial No." <> '') and
               ("From Bin Code" <> '') and
               ItemTrackingCode."SN Specific Tracking" and
               ("From Bin Code" <> Location."Adjustment Bin Code") and
               (((Location."Adjustment Bin Code" <> '') and
                 ("Entry Type" = "entry type"::Movement)) or
                (("Entry Type" <> "entry type"::Movement) or
                 ("Source Document" = "source document"::"Reclass. Jnl.")))
            then
              CheckSerialNo(
                "Item No.","Variant Code","Location Code","From Bin Code",
                "Unit of Measure Code","Serial No.",CalcReservEntryQuantity(WhseJnlLine));

            if ("Lot No." <> '') and
               ("From Bin Code" <> '') and
               ItemTrackingCode."Lot Specific Tracking" and
               ("From Bin Code" <> Location."Adjustment Bin Code") and
               (((Location."Adjustment Bin Code" <> '') and
                 ("Entry Type" = "entry type"::Movement)) or
                (("Entry Type" <> "entry type"::Movement) or
                 ("Source Document" = "source document"::"Reclass. Jnl.")))
            then
              CheckLotNo(
                "Item No.","Variant Code","Location Code","From Bin Code",
                "Unit of Measure Code","Lot No.",CalcReservEntryQuantity(WhseJnlLine))
          end;

          if "Entry Type" in ["entry type"::"Positive Adjmt.","entry type"::Movement] then
            if SourceJnl = Sourcejnl::" " then begin
              if Location."Directed Put-away and Pick" and ("To Zone Code" = '') then
                Error(
                  Text006,
                  FieldCaption("Zone Code"),"Whse. Document Type",
                  FieldCaption("Whse. Document No."),"Whse. Document No.",
                  FieldCaption("Line No."),"Whse. Document Line No.");
              if "To Bin Code" = '' then
                Error(
                  Text006,
                  FieldCaption("Bin Code"),"Whse. Document Type",
                  FieldCaption("Whse. Document No."),"Whse. Document No.",
                  FieldCaption("Line No."),"Whse. Document Line No.");
            end else
              if ("Entry Type" <> "entry type"::Movement) or ToTransfer then begin
                if Location."Directed Put-away and Pick" then
                  TestField("To Zone Code");
                TestField("To Bin Code");
              end;
          if "Entry Type" in ["entry type"::"Negative Adjmt.","entry type"::Movement] then
            if SourceJnl = Sourcejnl::" " then begin
              if Location."Directed Put-away and Pick" and ("From Zone Code" = '') then
                Error(
                  Text006,
                  FieldCaption("Zone Code"),"Whse. Document Type",
                  FieldCaption("Whse. Document No."),"Whse. Document No.",
                  FieldCaption("Line No."),"Whse. Document Line No.");
              if "From Bin Code" = '' then
                Error(
                  Text006,
                  FieldCaption("Bin Code"),"Whse. Document Type",
                  FieldCaption("Whse. Document No."),"Whse. Document No.",
                  FieldCaption("Line No."),"Whse. Document Line No.");
            end else
              if ("Entry Type" <> "entry type"::Movement) or not ToTransfer then begin
                if Location."Directed Put-away and Pick" then
                  TestField("From Zone Code");
                TestField("From Bin Code");
              end;

          QtyAbsBase := "Qty. (Absolute, Base)";
          case SourceJnl of
            Sourcejnl::" ",Sourcejnl::ItemJnl:
              begin
                if ("From Bin Code" <> '') and
                   ("From Bin Code" <> Location."Adjustment Bin Code") and
                   Location."Directed Put-away and Pick"
                then begin
                  BinContent.Get(
                    "Location Code","From Bin Code",
                    "Item No.","Variant Code","Unit of Measure Code");
                  BinContent.CheckDecreaseBinContent("Qty. (Absolute)","Qty. (Absolute, Base)",DecreaseQtyBase);
                end;

                if ("To Bin Code" <> '') and
                   ("To Bin Code" <> Location."Adjustment Bin Code") and
                   Location."Directed Put-away and Pick"
                then
                  if BinContent.Get(
                       "Location Code","To Bin Code",
                       "Item No.","Variant Code","Unit of Measure Code")
                  then begin
                    if ("Reference Document" = "reference document"::"Posted Rcpt.") or
                       ("Reference Document" = "reference document"::"Posted Rtrn. Rcpt.") or
                       ("Reference Document" = "reference document"::"Posted T. Receipt")
                    then
                      BinContent.CheckIncreaseBinContent(
                        "Qty. (Absolute, Base)",0,Cubage,Weight,Cubage,Weight,true,false)
                    else
                      BinContent.CheckIncreaseBinContent(
                        "Qty. (Absolute, Base)","Qty. (Absolute, Base)",Cubage,Weight,Cubage,Weight,true,false)
                  end else begin
                    GetBin("Location Code","To Bin Code");
                    Bin.CheckIncreaseBin(
                      Bin.Code,"Item No.","Qty. (Absolute)",Cubage,Weight,Cubage,Weight,true,false);
                  end;
              end;
            Sourcejnl::OutputJnl,Sourcejnl::ConsumpJnl:
              begin
                if ("From Bin Code" <> '') and
                   Location."Directed Put-away and Pick"
                then begin
                  BinContent.Get(
                    "Location Code","From Bin Code",
                    "Item No.","Variant Code","Unit of Measure Code");
                  BinContent.CheckDecreaseBinContent("Qty. (Absolute)","Qty. (Absolute, Base)",DecreaseQtyBase);
                end;

                if ("To Bin Code" <> '') and
                   Location."Directed Put-away and Pick"
                then
                  if BinContent.Get(
                       "Location Code","To Bin Code",
                       "Item No.","Variant Code","Unit of Measure Code")
                  then
                    BinContent.CheckIncreaseBinContent(
                      "Qty. (Absolute)","Qty. (Absolute)",Cubage,Weight,Cubage,Weight,true,false)
                  else begin
                    GetBin("Location Code","To Bin Code");
                    Bin.CheckIncreaseBin(
                      Bin.Code,"Item No.","Qty. (Absolute)",Cubage,Weight,Cubage,Weight,true,false);
                  end;
              end;
            Sourcejnl::WhseJnl:
              begin
                if ("From Bin Code" <> '') and
                   ("From Bin Code" <> Location."Adjustment Bin Code") and
                   Location."Directed Put-away and Pick"
                then begin
                  ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.",WhseSNRequired,WhseLNRequired,false);
                  if not (WhseSNRequired or WhseLNRequired) then begin
                    BinContent.Get(
                      "Location Code","From Bin Code",
                      "Item No.","Variant Code","Unit of Measure Code");
                    BinContent.CheckDecreaseBinContent("Qty. (Absolute)","Qty. (Absolute, Base)",DecreaseQtyBase);
                  end;
                end;
                if ("To Bin Code" <> '') and
                   ("To Bin Code" <> Location."Adjustment Bin Code") and
                   Location."Directed Put-away and Pick"
                then begin
                  GetBin("Location Code","To Bin Code");
                  Bin.CheckWhseClass("Item No.",false);
                end;
              end;
          end;
          if QtyAbsBase <> "Qty. (Absolute, Base)" then begin
            Validate("Qty. (Absolute, Base)");
            Modify;
          end;
        end;
    end;

    local procedure CheckAdjBinCode(WhseJnlLine: Record "Warehouse Journal Line")
    var
        WarehouseJournalTemplate: Record "Warehouse Journal Template";
        FieldCapTxt: Text;
    begin
        with WhseJnlLine do begin
          if "Entry Type" = "entry type"::Movement then
            exit;

          GetLocation("Location Code");
          if not Location."Directed Put-away and Pick" then
            exit;

          WarehouseJournalTemplate.Get("Journal Template Name");
          if WarehouseJournalTemplate.Type = WarehouseJournalTemplate.Type::Reclassification then
            exit;

          Location.TestField("Adjustment Bin Code");
          case "Entry Type" of
            "entry type"::"Positive Adjmt.":
              if ("From Bin Code" <> '') and ("From Bin Code" <> Location."Adjustment Bin Code") then
                FieldCapTxt := FieldCaption("From Bin Code");
            "entry type"::"Negative Adjmt.":
              if ("To Bin Code" <> '') and ("To Bin Code" <> Location."Adjustment Bin Code") then
                FieldCapTxt := FieldCaption("To Bin Code");
          end;
          if FieldCapTxt <> '' then
            Error(
              Text006,
              StrSubstNo('%1 = ''%2''',FieldCapTxt,Location."Adjustment Bin Code"),
              "Whse. Document Type",
              FieldCaption("Whse. Document No."),"Whse. Document No.",
              FieldCaption("Line No."),"Line No.");
        end;
    end;


    procedure CheckItemJnlLineFieldChange(ItemJnlLine: Record "Item Journal Line";xItemJnlLine: Record "Item Journal Line";CurrFieldCaption: Text[30])
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComponent: Record "Prod. Order Component";
        WhseItemJnl: Page "Whse. Item Journal";
        WhsePhysInvJnl: Page "Whse. Phys. Invt. Journal";
        BinIsEligible: Boolean;
    begin
        with ItemJnlLine do begin
          if ("Order Type" = "order type"::Production) and ("Entry Type" = "entry type"::Output) then
            if ProdOrderLine.Get(ProdOrderLine.Status::Released,"Order No.","Order Line No.") then
              BinIsEligible := ("Location Code" = ProdOrderLine."Location Code") and ("Bin Code" = ProdOrderLine."Bin Code");
          if ("Order Type" = "order type"::Production) and ("Entry Type" = "entry type"::Consumption) then
            if ProdOrderComponent.Get(ProdOrderComponent.Status::Released,"Order No.","Order Line No.","Prod. Order Comp. Line No.") then
              BinIsEligible := ("Location Code" = ProdOrderComponent."Location Code") and ("Bin Code" = ProdOrderComponent."Bin Code");

          ShowError := CheckBinCodeChange("Location Code","Bin Code",xItemJnlLine."Bin Code") and not BinIsEligible;
          if not ShowError then
            ShowError := CheckBinCodeChange("New Location Code","New Bin Code",xItemJnlLine."New Bin Code");

          if ShowError then
            Error(Text015,
              CurrFieldCaption,
              Lowercase(Location.TableCaption),Location.Code,Location.FieldCaption("Directed Put-away and Pick"));

          if "Entry Type" in
             ["entry type"::"Negative Adjmt.","entry type"::"Positive Adjmt.","entry type"::Sale,"entry type"::Purchase]
          then begin
            if ("Location Code" <> xItemJnlLine."Location Code") and (xItemJnlLine."Location Code" <> '') then begin
              GetLocation(xItemJnlLine."Location Code");
              ShowError := Location."Directed Put-away and Pick";
            end;

            if (("Item No." <> xItemJnlLine."Item No.") and (xItemJnlLine."Item No." <> '')) or
               ((Quantity <> xItemJnlLine.Quantity) and (xItemJnlLine.Quantity <> 0)) or
               ("Variant Code" <> xItemJnlLine."Variant Code") or
               ("Unit of Measure Code" <> xItemJnlLine."Unit of Measure Code") or
               ("Entry Type" <> xItemJnlLine."Entry Type") or
               ("Phys. Inventory" and
                ("Qty. (Phys. Inventory)" <> xItemJnlLine."Qty. (Phys. Inventory)") or
                (Quantity <> xItemJnlLine.Quantity))
            then begin
              GetLocation("Location Code");
              ShowError := Location."Directed Put-away and Pick";
            end;

            if ShowError then begin
              if "Phys. Inventory" then
                Error(Text010,
                  CurrFieldCaption,
                  Location.TableCaption,Location.Code,Location.FieldCaption("Directed Put-away and Pick"),
                  WhsePhysInvJnl.Caption);

              Error(Text010,
                CurrFieldCaption,
                Location.TableCaption,Location.Code,Location.FieldCaption("Directed Put-away and Pick"),
                WhseItemJnl.Caption);
            end;
          end;
        end;
    end;


    procedure CheckItemJnlLineLocation(var ItemJnlLine: Record "Item Journal Line";xItemJnlLine: Record "Item Journal Line")
    var
        WhseItemJnl: Page "Whse. Item Journal";
        TransferOrder: Page "Transfer Order";
    begin
        with ItemJnlLine do begin
          if "Entry Type" in
             ["entry type"::"Negative Adjmt.","entry type"::"Positive Adjmt.","entry type"::Sale,"entry type"::Purchase]
          then
            if "Location Code" <> xItemJnlLine."Location Code" then begin
              GetLocation(xItemJnlLine."Location Code");
              if not Location."Directed Put-away and Pick" then begin
                GetLocation("Location Code");
                if Location."Directed Put-away and Pick" then
                  Error(Text011,
                    Lowercase(Location.TableCaption),Location.Code,Location.FieldCaption("Directed Put-away and Pick"),
                    WhseItemJnl.Caption);
              end;
            end;

          if "Entry Type" = "entry type"::Transfer then begin
            if ("New Location Code" <> "Location Code") and
               (("Location Code" <> xItemJnlLine."Location Code") or
                ("New Location Code" <> xItemJnlLine."New Location Code"))
            then begin
              GetLocation("Location Code");
              ShowError := Location."Directed Put-away and Pick";
              if not Location."Directed Put-away and Pick" then begin
                GetLocation("New Location Code");
                ShowError := Location."Directed Put-away and Pick";
              end;
            end;

            if ShowError then
              Error(Text012,
                Lowercase(Location.TableCaption),Location.Code,Location.FieldCaption("Directed Put-away and Pick"),
                TransferOrder.Caption);
          end;
        end;
    end;


    procedure CheckItemTrackingChange(TrackingSpecification: Record "Tracking Specification";xTrackingSpecification: Record "Tracking Specification")
    begin
        with TrackingSpecification do
          if ("Source Type" = Database::"Item Journal Line") and
             ("Item No." <> '') and
             ("Location Code" <> '')
          then begin
            if "Source Subtype" in [0,1,2,3] then
              if ("Lot No." <> xTrackingSpecification."Lot No.") or
                 ("Serial No." <> xTrackingSpecification."Serial No.") or
                 ((xTrackingSpecification."Expiration Date" <> 0D) and
                  ("Expiration Date" <> xTrackingSpecification."Expiration Date")) or
                 ("Quantity (Base)" <> xTrackingSpecification."Quantity (Base)")
              then begin
                GetLocation("Location Code");
                if Location."Directed Put-away and Pick" then begin
                  GetItem("Item No.");
                  if ItemTrackingCode."SN Warehouse Tracking" or ItemTrackingCode."Lot Warehouse Tracking" then
                    Error(Text013,
                      Lowercase(Item.TableCaption),
                      Lowercase(Location.TableCaption),Location.Code,Location.FieldCaption("Directed Put-away and Pick"));
                end;
              end;

            if IsReclass then
              if ("New Lot No." <> "Lot No.") and
                 (("Lot No." <> xTrackingSpecification."Lot No.") or
                  ("New Lot No." <> xTrackingSpecification."New Lot No.")) or
                 ("New Serial No." <> "Serial No.") and
                 (("Serial No." <> xTrackingSpecification."Serial No.") or
                  ("New Serial No." <> xTrackingSpecification."New Serial No.")) or
                 ("New Expiration Date" <> "Expiration Date") and
                 (("Expiration Date" <> xTrackingSpecification."Expiration Date") or
                  ("New Expiration Date" <> xTrackingSpecification."New Expiration Date"))
              then begin
                GetLocation("Location Code");
                if Location."Directed Put-away and Pick" then begin
                  GetItem("Item No.");
                  if ItemTrackingCode."SN Warehouse Tracking" or ItemTrackingCode."Lot Warehouse Tracking" then
                    Error(Text014,
                      Lowercase(Item.TableCaption),
                      Lowercase(Location.TableCaption),Location.Code,Location.FieldCaption("Directed Put-away and Pick"));
                end;
              end;
          end;
    end;

    local procedure CheckBinCodeChange(LocationCode: Code[10];BinCode: Code[20];xRecBinCode: Code[20]): Boolean
    begin
        if (BinCode <> xRecBinCode) and (BinCode <> '') then begin
          GetLocation(LocationCode);
          exit(Location."Directed Put-away and Pick");
        end;

        exit(false);
    end;


    procedure CheckAdjmtBin(Location: Record Location;Quantity: Decimal;PosEntryType: Boolean)
    begin
        if not Location."Directed Put-away and Pick" then
          exit;

        Location.TestField(Code);
        Location.TestField("Adjustment Bin Code");
        GetBin(Location.Code,Location."Adjustment Bin Code");

        // Test whether bin movement is blocked for current Entry Type
        if (PosEntryType and (Quantity > 0)) or
           (not PosEntryType and (Quantity < 0))
        then
          ShowError := (Bin."Block Movement" in
                        [Bin."block movement"::Inbound,Bin."block movement"::All])
        else
          if (PosEntryType and (Quantity < 0)) or
             (not PosEntryType and (Quantity > 0))
          then
            ShowError := (Bin."Block Movement" in
                          [Bin."block movement"::Outbound,Bin."block movement"::All]);

        if ShowError then
          Bin.FieldError(
            "Block Movement",
            StrSubstNo(
              Text000,
              Bin."Block Movement"));
    end;


    procedure CheckInbOutbBin(LocationCode: Code[10];BinCode: Code[20];CheckInbound: Boolean)
    begin
        GetLocation(LocationCode);
        GetBin(LocationCode,BinCode);

        // Test whether bin movement is blocked for current Entry Type
        if CheckInbound then
          if Bin."Block Movement" in [Bin."block movement"::Inbound,Bin."block movement"::All] then
            Bin.FieldError("Block Movement",StrSubstNo(Text000,Bin."Block Movement"));

        if not CheckInbound then
          if Bin."Block Movement" in [Bin."block movement"::Outbound,Bin."block movement"::All] then
            Bin.FieldError("Block Movement",StrSubstNo(Text000,Bin."Block Movement"));
    end;

    local procedure CheckUserIsWhseEmployee()
    var
        WhseEmployee: Record "Warehouse Employee";
    begin
        if UserId <> '' then begin
          WhseEmployee.SetRange("User ID",UserId);
          if WhseEmployee.IsEmpty then
            Error(UserIsNotWhseEmployeeErr,UserId);
        end;
    end;


    procedure CalcCubageAndWeight(ItemNo: Code[20];UOMCode: Code[10];Qty: Decimal;var Cubage: Decimal;var Weight: Decimal)
    begin
        if ItemNo <> '' then begin
          GetItemUnitOfMeasure(ItemNo,UOMCode);
          Cubage := Qty * ItemUnitOfMeasure.Cubage;
          Weight := Qty * ItemUnitOfMeasure.Weight;
        end else begin
          Cubage := 0;
          Weight := 0;
        end;
    end;


    procedure GetDefaultLocation(): Code[10]
    var
        WhseEmployee: Record "Warehouse Employee";
    begin
        if UserId <> '' then begin
          WhseEmployee.SetCurrentkey(Default);
          WhseEmployee.SetRange(Default,true);
          WhseEmployee.SetRange("User ID",UserId);
          if not WhseEmployee.FindFirst then
            Error(Text003,UserId);
          exit(WhseEmployee."Location Code");
        end;
    end;


    procedure GetDefaultBin(ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];var BinCode: Code[20]): Boolean
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.SetCurrentkey(Default);
        BinContent.SetRange(Default,true);
        BinContent.SetRange("Location Code",LocationCode);
        BinContent.SetRange("Item No.",ItemNo);
        BinContent.SetRange("Variant Code",VariantCode);
        if BinContent.FindFirst then begin
          BinCode := BinContent."Bin Code";
          exit(true);
        end;
    end;


    procedure CheckDefaultBin(ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];BinCode: Code[20]): Boolean
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.SetCurrentkey(Default);
        BinContent.SetRange(Default,true);
        BinContent.SetRange("Location Code",LocationCode);
        BinContent.SetRange("Item No.",ItemNo);
        BinContent.SetRange("Variant Code",VariantCode);
        BinContent.SetFilter("Bin Code",'<>%1',BinCode);
        exit(not BinContent.IsEmpty);
    end;


    procedure CheckBalanceQtyToHandle(var WhseActivLine2: Record "Warehouse Activity Line")
    var
        WhseActivLine: Record "Warehouse Activity Line";
        WhseActivLine3: Record "Warehouse Activity Line";
        TempWhseActivLine: Record "Warehouse Activity Line" temporary;
        QtyToPick: Decimal;
        QtyToPutAway: Decimal;
        ErrorText: Text[250];
    begin
        WhseActivLine.Copy(WhseActivLine2);
        with WhseActivLine do begin
          SetCurrentkey("Activity Type","No.","Item No.","Variant Code","Action Type");
          SetRange("Activity Type","Activity Type");
          SetRange("No.","No.");
          SetRange("Action Type");
          if FindSet then
            repeat
              if not TempWhseActivLine.Get("Activity Type","No.","Line No.") then begin
                WhseActivLine3.Copy(WhseActivLine);

                WhseActivLine3.SetRange("Item No.","Item No.");
                WhseActivLine3.SetRange("Variant Code","Variant Code");
                WhseActivLine3.SetRange("Serial No.","Serial No.");
                WhseActivLine3.SetRange("Lot No.","Lot No.");

                if (WhseActivLine2."Action Type" = WhseActivLine2."action type"::Take) or
                   (WhseActivLine2.GetFilter("Action Type") = '')
                then begin
                  WhseActivLine3.SetRange("Action Type",WhseActivLine3."action type"::Take);
                  if WhseActivLine3.FindSet then
                    repeat
                      QtyToPick := QtyToPick + WhseActivLine3."Qty. to Handle (Base)";
                      TempWhseActivLine := WhseActivLine3;
                      TempWhseActivLine.Insert;
                    until WhseActivLine3.Next = 0;
                end;

                if (WhseActivLine2."Action Type" = WhseActivLine2."action type"::Place) or
                   (WhseActivLine2.GetFilter("Action Type") = '')
                then begin
                  WhseActivLine3.SetRange("Action Type",WhseActivLine3."action type"::Place);
                  if WhseActivLine3.FindSet then
                    repeat
                      QtyToPutAway := QtyToPutAway + WhseActivLine3."Qty. to Handle (Base)";
                      TempWhseActivLine := WhseActivLine3;
                      TempWhseActivLine.Insert;
                    until WhseActivLine3.Next = 0;
                end;

                if QtyToPick <> QtyToPutAway then begin
                  if (WhseActivLine3.GetFilter("Serial No.") <> '') or
                     (WhseActivLine3.GetFilter("Lot No.") <> '')
                  then
                    ErrorText :=
                      StrSubstNo(
                        Text016,
                        FieldCaption("Item No."),"Item No.",
                        FieldCaption("Variant Code"),"Variant Code",
                        FieldCaption("Lot No."),"Lot No.",
                        FieldCaption("Serial No."),"Serial No.",
                        QtyToPick,QtyToPutAway)
                  else
                    ErrorText :=
                      StrSubstNo(
                        Text005,
                        FieldCaption("Item No."),"Item No.",FieldCaption("Variant Code"),
                        "Variant Code",QtyToPick,QtyToPutAway);
                  HandleError(ErrorText);
                end;

                QtyToPick := 0;
                QtyToPutAway := 0;
              end;
            until Next = 0;
        end;
    end;


    procedure CheckPutAwayAvailability(BinCode: Code[20];CheckFieldCaption: Text[100];CheckTableCaption: Text[100];ValueToPutAway: Decimal;ValueAvailable: Decimal;Prohibit: Boolean)
    begin
        if ValueToPutAway <= ValueAvailable then
          exit;
        if Prohibit then
          Error(
            StrSubstNo(
              Text004,CheckFieldCaption,ValueToPutAway,ValueAvailable,
              CheckTableCaption,BinCode));

        if not Confirm(
             StrSubstNo(
               Text004,CheckFieldCaption,ValueToPutAway,ValueAvailable,
               CheckTableCaption,BinCode) + StrSubstNo(Text002,CheckTableCaption),false)
        then
          Error(Text007);
    end;


    procedure InitErrorLog()
    begin
        LogErrors := true;
        TempErrorLog.DeleteAll;
        NextLineNo := 1;
    end;

    local procedure HandleError(ErrorText: Text[250])
    var
        Position: Integer;
    begin
        if LogErrors then begin
          Position := StrPos(ErrorText,'\');
          if Position = 0 then
            InsertErrorLog(ErrorText)
          else begin
            repeat
              InsertErrorLog(CopyStr(ErrorText,1,Position - 1));
              ErrorText := DelStr(ErrorText,1,Position);
              Position := StrPos(ErrorText,'\');
            until Position = 0;
            InsertErrorLog(ErrorText);
            InsertErrorLog('');
          end;
        end else
          Error(ErrorText);
    end;

    local procedure InsertErrorLog(ErrorText: Text[250])
    begin
        TempErrorLog."Line No." := NextLineNo;
        TempErrorLog.Text := ErrorText;
        TempErrorLog.Insert;
        NextLineNo := NextLineNo + 1;
    end;


    procedure GetAllowedLocation(LocationCode: Code[10]): Code[10]
    var
        WhseEmployee: Record "Warehouse Employee";
    begin
        CheckUserIsWhseEmployee;
        if WhseEmployee.Get(UserId,LocationCode) then
          exit(LocationCode);
        exit(GetDefaultLocation);
    end;


    procedure LocationIsAllowed(LocationCode: Code[10]): Boolean
    var
        WhseEmployee: Record "Warehouse Employee";
    begin
        exit(WhseEmployee.Get(UserId,LocationCode) or (UserId = ''))
    end;


    procedure LocationIsAllowedToView(LocationCode: Code[10]): Boolean
    begin
        exit((LocationCode = '') or LocationIsAllowed(LocationCode))
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Clear(Location)
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;

    local procedure GetBin(LocationCode: Code[10];BinCode: Code[20])
    begin
        if (Bin."Location Code" <> LocationCode) or
           (Bin.Code <> BinCode)
        then
          Bin.Get(LocationCode,BinCode);

        GetLocation(LocationCode);
        if Location."Directed Put-away and Pick" then
          Bin.TestField("Zone Code");
    end;

    local procedure GetItemUnitOfMeasure(ItemNo: Code[20];UOMCode: Code[10])
    begin
        if (ItemUnitOfMeasure."Item No." <> ItemNo) or
           (ItemUnitOfMeasure.Code <> UOMCode)
        then
          if not ItemUnitOfMeasure.Get(ItemNo,UOMCode) then
            ItemUnitOfMeasure.Init;
    end;


    procedure GetBaseUOM(ItemNo: Code[20]): Code[10]
    begin
        GetItem(ItemNo);
        exit(Item."Base Unit of Measure");
    end;

    local procedure GetItem(ItemNo: Code[20])
    begin
        if ItemNo = Item."No." then
          exit;

        Item.Get(ItemNo);
        if Item."Item Tracking Code" <> '' then
          ItemTrackingCode.Get(Item."Item Tracking Code")
        else
          Clear(ItemTrackingCode);
    end;

    local procedure GetProdOrderCompLine(var ProdOrderCompLine: Record "Prod. Order Component";Status: Option;ProdOrderNo: Code[20];ProdOrderLineNo: Integer;ProdOrdCompLineNo: Integer): Boolean
    begin
        if (ProdOrderNo = '') or
           (ProdOrderLineNo = 0) or
           (ProdOrdCompLineNo = 0)
        then
          exit(false);
        if (ProdOrderCompLine.Status <> Status) or
           (ProdOrderCompLine."Prod. Order No." <> ProdOrderNo) or
           (ProdOrderCompLine."Prod. Order Line No." <> ProdOrderLineNo) or
           (ProdOrderCompLine."Line No." <> ProdOrdCompLineNo)
        then begin
          if ProdOrderCompLine.Get(Status,ProdOrderNo,ProdOrderLineNo,ProdOrdCompLineNo) then
            exit(true);

          exit(false);
        end;
        exit(true);
    end;


    procedure ShowWhseDocLine(WhseDocType: Option Receipt,"Posted Receipt",Shipment,"Internal Put-away","Internal Pick",Production,,Assembly;WhseDocNo: Code[20];WhseDocLineNo: Integer)
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        WhseShptLine: Record "Warehouse Shipment Line";
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        WhseInternalPickLine: Record "Whse. Internal Pick Line";
        WhseInternalPutawayLine: Record "Whse. Internal Put-away Line";
        ProdOrderLine: Record "Prod. Order Line";
        AssemblyLine: Record "Assembly Line";
    begin
        case WhseDocType of
          Whsedoctype::Receipt:
            begin
              WhseRcptLine.Reset;
              WhseRcptLine.SetRange("No.",WhseDocNo);
              WhseRcptLine.SetRange("Line No.",WhseDocLineNo);
              Page.RunModal(Page::"Whse. Receipt Lines",WhseRcptLine);
            end;
          Whsedoctype::"Posted Receipt":
            begin
              PostedWhseRcptLine.Reset;
              PostedWhseRcptLine.SetRange("No.",WhseDocNo);
              PostedWhseRcptLine.SetRange("Line No.",WhseDocLineNo);
              Page.RunModal(Page::"Posted Whse. Receipt Lines",PostedWhseRcptLine);
            end;
          Whsedoctype::Shipment:
            begin
              WhseShptLine.Reset;
              WhseShptLine.SetRange("No.",WhseDocNo);
              WhseShptLine.SetRange("Line No.",WhseDocLineNo);
              Page.RunModal(Page::"Whse. Shipment Lines",WhseShptLine);
            end;
          Whsedoctype::"Internal Put-away":
            begin
              WhseInternalPutawayLine.Reset;
              WhseInternalPutawayLine.SetRange("No.",WhseDocNo);
              WhseInternalPutawayLine.SetRange("Line No.",WhseDocLineNo);
              Page.RunModal(Page::"Whse. Internal Put-away Lines",WhseInternalPutawayLine);
            end;
          Whsedoctype::"Internal Pick":
            begin
              WhseInternalPickLine.Reset;
              WhseInternalPickLine.SetRange("No.",WhseDocNo);
              WhseInternalPickLine.SetRange("Line No.",WhseDocLineNo);
              Page.RunModal(Page::"Whse. Internal Pick Lines",WhseInternalPickLine);
            end;
          Whsedoctype::Production:
            begin
              ProdOrderLine.Reset;
              ProdOrderLine.SetRange(Status,ProdOrderLine.Status::Released);
              ProdOrderLine.SetRange("Prod. Order No.",WhseDocNo);
              ProdOrderLine.SetRange("Line No.",WhseDocLineNo);
              Page.RunModal(Page::"Prod. Order Line List",ProdOrderLine);
            end;
          Whsedoctype::Assembly:
            begin
              AssemblyLine.SetRange("Document Type",AssemblyLine."document type"::Order);
              AssemblyLine.SetRange("Document No.",WhseDocNo);
              AssemblyLine.SetRange("Line No.",WhseDocLineNo);
              Page.RunModal(Page::"Assembly Lines",AssemblyLine);
            end;
        end;
    end;


    procedure ShowPostedWhseShptLine(WhseDocNo: Code[20];WhseDocLineNo: Integer)
    var
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
    begin
        PostedWhseShptLine.Reset;
        PostedWhseShptLine.SetCurrentkey("Whse. Shipment No.","Whse Shipment Line No.");
        PostedWhseShptLine.SetRange("Whse. Shipment No.",WhseDocNo);
        PostedWhseShptLine.SetRange("Whse Shipment Line No.",WhseDocLineNo);
        Page.RunModal(Page::"Posted Whse. Shipment Lines",PostedWhseShptLine);
    end;


    procedure ShowSourceDocLine(SourceType: Integer;SourceSubType: Option;SourceNo: Code[20];SourceLineNo: Integer;SourceSubLineNo: Integer)
    var
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        ProdOrderComp: Record "Prod. Order Component";
        AssemblyLine: Record "Assembly Line";
        ServiceLine: Record "Service Line";
    begin
        case SourceType of
          Database::"Sales Line":
            begin
              SalesLine.Reset;
              SalesLine.SetRange("Document Type",SourceSubType);
              SalesLine.SetRange("Document No.",SourceNo);
              SalesLine.SetRange("Line No.",SourceLineNo);
              Page.RunModal(Page::"Sales Lines",SalesLine);
            end;
          Database::"Purchase Line":
            begin
              PurchLine.Reset;
              PurchLine.SetRange("Document Type",SourceSubType);
              PurchLine.SetRange("Document No.",SourceNo);
              PurchLine.SetRange("Line No.",SourceLineNo);
              Page.RunModal(Page::"Purchase Lines",PurchLine);
            end;
          Database::"Transfer Line":
            begin
              TransLine.Reset;
              TransLine.SetRange("Document No.",SourceNo);
              TransLine.SetRange("Line No.",SourceLineNo);
              Page.RunModal(Page::"Transfer Lines",TransLine);
            end;
          Database::"Prod. Order Component":
            begin
              ProdOrderComp.Reset;
              ProdOrderComp.SetRange(Status,SourceSubType);
              ProdOrderComp.SetRange("Prod. Order No.",SourceNo);
              ProdOrderComp.SetRange("Prod. Order Line No.",SourceLineNo);
              ProdOrderComp.SetRange("Line No.",SourceSubLineNo);
              case SourceSubType of
                3: // Released
                  Page.RunModal(Page::"Prod. Order Comp. Line List",ProdOrderComp);
              end;
            end;
          Database::"Assembly Line":
            begin
              AssemblyLine.SetRange("Document Type",SourceSubType);
              AssemblyLine.SetRange("Document No.",SourceNo);
              AssemblyLine.SetRange("Line No.",SourceLineNo);
              Page.RunModal(Page::"Assembly Lines",AssemblyLine);
            end;
          Database::"Service Line":
            begin
              ServiceLine.SetRange("Document Type",SourceSubType);
              ServiceLine.SetRange("Document No.",SourceNo);
              ServiceLine.SetRange("Line No.",SourceLineNo);
              Page.Run(Page::"Service Line List",ServiceLine);
            end;
        end;
    end;


    procedure ShowPostedSourceDoc(PostedSourceDoc: Option " ","Posted Receipt",,"Posted Return Receipt",,"Posted Shipment",,"Posted Return Shipment",,"Posted Transfer Receipt","Posted Transfer Shipment";PostedSourceNo: Code[20])
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        ReturnShipmentHeader: Record "Return Shipment Header";
        ReturnReceiptHeader: Record "Return Receipt Header";
        TransShipmentHeader: Record "Transfer Shipment Header";
        TransReceiptHeader: Record "Transfer Receipt Header";
    begin
        case PostedSourceDoc of
          Postedsourcedoc::"Posted Shipment":
            begin
              SalesShipmentHeader.Reset;
              SalesShipmentHeader.SetRange("No.",PostedSourceNo);
              Page.RunModal(Page::"Posted Sales Shipment",SalesShipmentHeader);
            end;
          Postedsourcedoc::"Posted Receipt":
            begin
              PurchRcptHeader.Reset;
              PurchRcptHeader.SetRange("No.",PostedSourceNo);
              Page.RunModal(Page::"Posted Purchase Receipt",PurchRcptHeader);
            end;
          Postedsourcedoc::"Posted Return Shipment":
            begin
              ReturnShipmentHeader.Reset;
              ReturnShipmentHeader.SetRange("No.",PostedSourceNo);
              Page.RunModal(Page::"Posted Return Shipment",ReturnShipmentHeader);
            end;
          Postedsourcedoc::"Posted Return Receipt":
            begin
              ReturnReceiptHeader.Reset;
              ReturnReceiptHeader.SetRange("No.",PostedSourceNo);
              Page.RunModal(Page::"Posted Return Receipt",ReturnReceiptHeader);
            end;
          Postedsourcedoc::"Posted Transfer Shipment":
            begin
              TransShipmentHeader.Reset;
              TransShipmentHeader.SetRange("No.",PostedSourceNo);
              Page.RunModal(Page::"Posted Transfer Shipment",TransShipmentHeader);
            end;
          Postedsourcedoc::"Posted Transfer Receipt":
            begin
              TransReceiptHeader.Reset;
              TransReceiptHeader.SetRange("No.",PostedSourceNo);
              Page.RunModal(Page::"Posted Transfer Receipt",TransReceiptHeader);
            end;
        end;
    end;


    procedure ShowSourceDocCard(SourceType: Integer;SourceSubType: Option;SourceNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        TransHeader: Record "Transfer Header";
        ProdOrder: Record "Production Order";
        AssemblyHeader: Record "Assembly Header";
    begin
        case SourceType of
          Database::"Sales Line":
            begin
              SalesHeader.SetRange("Document Type",SourceSubType);
              if SalesHeader.Get(SourceSubType,SourceNo) then
                if SalesHeader."Document Type" = SalesHeader."document type"::Order then
                  Page.RunModal(Page::"Sales Order",SalesHeader)
                else
                  Page.RunModal(Page::"Sales Return Order",SalesHeader);
            end;
          Database::"Purchase Line":
            begin
              PurchHeader.SetRange("Document Type",SourceSubType);
              if PurchHeader.Get(SourceSubType,SourceNo) then
                if PurchHeader."Document Type" = PurchHeader."document type"::Order then
                  Page.RunModal(Page::"Purchase Order",PurchHeader)
                else
                  Page.RunModal(Page::"Purchase Return Order",PurchHeader);
            end;
          Database::"Transfer Line":
            begin
              if TransHeader.Get(SourceNo) then
                Page.RunModal(Page::"Transfer Order",TransHeader);
            end;
          Database::"Prod. Order Line", Database::"Prod. Order Component":
            begin
              ProdOrder.SetRange(Status,SourceSubType);
              if ProdOrder.Get(SourceSubType,SourceNo) then
                Page.RunModal(Page::"Released Production Order",ProdOrder);
            end;
          Database::"Assembly Line":
            begin
              AssemblyHeader.SetRange("Document Type",SourceSubType);
              if AssemblyHeader.Get(SourceSubType,SourceNo) then
                Page.RunModal(Page::"Assembly Order",AssemblyHeader);
            end;
        end;
    end;

    local procedure TransferWhseItemTrkg(var WhseJnlLine: Record "Warehouse Journal Line";ItemJnlLine: Record "Item Journal Line")
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        WhseSNRequired: Boolean;
        WhseLNRequired: Boolean;
    begin
        ItemTrackingMgt.CheckWhseItemTrkgSetup(
          ItemJnlLine."Item No.",WhseSNRequired,WhseLNRequired,false);
        if not (WhseSNRequired or WhseLNRequired) then
          exit;
        if WhseSNRequired then begin
          WhseJnlLine.TestField("Qty. per Unit of Measure",1);
          WhseJnlLine."Serial No." := ItemJnlLine."Serial No.";
        end;
        if WhseLNRequired then
          WhseJnlLine."Lot No." := ItemJnlLine."Lot No.";
        WhseJnlLine."Warranty Date" := ItemJnlLine."Warranty Date";
        WhseJnlLine."Expiration Date" := ItemJnlLine."Item Expiration Date";
    end;


    procedure SetTransferLine(TransferLine: Record "Transfer Line";var WhseJnlLine: Record "Warehouse Journal Line";PostingType: Option Shipment,Receipt;PostedDocNo: Code[20])
    begin
        with TransferLine do begin
          WhseJnlLine."Source Type" := Database::"Transfer Line";
          WhseJnlLine."Source Subtype" := PostingType;
          WhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(WhseJnlLine."Source Type",WhseJnlLine."Source Subtype");
          WhseJnlLine."Source No." := "Document No.";
          WhseJnlLine."Source Line No." := "Line No.";
          if PostingType = Postingtype::Shipment then
            WhseJnlLine."Reference Document" := WhseJnlLine."reference document"::"Posted T. Shipment"
          else
            WhseJnlLine."Reference Document" := WhseJnlLine."reference document"::"Posted T. Receipt";
          WhseJnlLine."Reference No." := PostedDocNo;
          WhseJnlLine."Entry Type" := PostingType;
        end;
    end;


    procedure SerialNoOnInventory(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10];SerialNo: Code[20]): Boolean
    var
        WhseEntry: Record "Warehouse Entry";
    begin
        with WhseEntry do begin
          GetLocation(LocationCode);
          SetCurrentkey(
            "Item No.","Bin Code","Location Code","Variant Code",
            "Unit of Measure Code","Lot No.","Serial No.");
          SetRange("Item No.",ItemNo);
          SetFilter("Bin Code",'<>%1',Location."Adjustment Bin Code");
          SetRange("Location Code",LocationCode);
          SetRange("Variant Code",VariantCode);
          SetRange("Serial No.",SerialNo);
          CalcSums("Qty. (Base)");
          exit("Qty. (Base)" > 0);
        end;
    end;

    local procedure CheckSerialNo(ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];BinCode: Code[20];UOMCode: Code[10];SerialNo: Code[20];QuantityBase: Decimal)
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.Get(LocationCode,BinCode,ItemNo,VariantCode,UOMCode);
        BinContent.SetRange("Serial No. Filter",SerialNo);
        BinContent.CalcFields("Quantity (Base)");
        if BinContent."Quantity (Base)" < Abs(QuantityBase) then
          BinContent.FieldError(
            "Quantity (Base)",StrSubstNo(Text000,Abs(QuantityBase) - 1));
    end;

    local procedure CheckLotNo(ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];BinCode: Code[20];UOMCode: Code[10];LotNo: Code[20];QuantityBase: Decimal)
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.Get(LocationCode,BinCode,ItemNo,VariantCode,UOMCode);
        BinContent.SetRange("Lot No. Filter",LotNo);
        BinContent.CalcFields("Quantity (Base)");
        if BinContent."Quantity (Base)" < Abs(QuantityBase) then
          BinContent.FieldError(
            "Quantity (Base)",StrSubstNo(Text000,BinContent."Quantity (Base)" - Abs(QuantityBase)));
    end;


    procedure BinLookUp(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10];ZoneCode: Code[10]): Code[20]
    var
        Bin: Record Bin;
    begin
        Bin.SetRange("Location Code",LocationCode);
        Bin.SetRange("Item Filter",ItemNo);
        Bin.SetRange("Variant Filter",VariantCode);
        if ZoneCode <> '' then
          Bin.SetRange("Zone Code",ZoneCode);
        if Page.RunModal(0,Bin) = Action::LookupOK then
          exit(Bin.Code);
    end;


    procedure BinContentLookUp(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10];ZoneCode: Code[10];CurrBinCode: Code[20]): Code[20]
    begin
        exit(BinContentLookUp2(LocationCode,ItemNo,VariantCode,ZoneCode,'','',CurrBinCode));
    end;


    procedure BinContentLookUp2(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10];ZoneCode: Code[10];LotNo: Code[20];SerialNo: Code[20];CurrBinCode: Code[20]): Code[20]
    var
        BinContent: Record "Bin Content";
    begin
        GetItem(ItemNo);
        BinContent.SetCurrentkey("Location Code","Item No.","Variant Code");
        BinContent.SetRange("Location Code",LocationCode);
        BinContent.SetRange("Item No.",ItemNo);
        BinContent.SetRange("Variant Code",VariantCode);

        if ItemTrackingCode."SN Warehouse Tracking" then
          if SerialNo <> '' then
            BinContent.SetRange("Serial No. Filter",SerialNo);
        if ItemTrackingCode."Lot Warehouse Tracking" then
          if LotNo <> '' then
            BinContent.SetRange("Lot No. Filter",LotNo);

        if ZoneCode <> '' then
          BinContent.SetRange("Zone Code",ZoneCode);

        BinContent.SetRange("Bin Code",CurrBinCode);
        if BinContent.FindFirst then;
        BinContent.SetRange("Bin Code");

        if Page.RunModal(0,BinContent) = Action::LookupOK then
          exit(BinContent."Bin Code");
    end;


    procedure FindBin(LocationCode: Code[10];BinCode: Code[20];ZoneCode: Code[10])
    var
        Bin: Record Bin;
    begin
        if ZoneCode <> '' then begin
          Bin.SetCurrentkey("Location Code","Zone Code",Code);
          Bin.SetRange("Location Code",LocationCode);
          Bin.SetRange("Zone Code",ZoneCode);
          Bin.SetRange(Code,BinCode);
          Bin.FindFirst;
        end else
          Bin.Get(LocationCode,BinCode);
    end;


    procedure FindBinContent(LocationCode: Code[10];BinCode: Code[20];ItemNo: Code[20];VariantCode: Code[10];ZoneCode: Code[10])
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.SetRange("Location Code",LocationCode);
        BinContent.SetRange("Bin Code",BinCode);
        BinContent.SetRange("Item No.",ItemNo);
        BinContent.SetRange("Variant Code",VariantCode);
        if ZoneCode <> '' then
          BinContent.SetRange("Zone Code",ZoneCode);
        BinContent.FindFirst;
    end;


    procedure CalcLineReservedQtyNotonInvt(SourceType: Integer;SourceSubType: Option;SourceNo: Code[20];SourceLineNo: Integer;SourceSubLineNo: Integer): Decimal
    var
        ReservEntry: Record "Reservation Entry";
        ReservQtyNotonInvt: Decimal;
    begin
        ReservEntry.SetCurrentkey(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line","Reservation Status");
        ReservEntry.SetRange("Source ID",SourceNo);
        ReservEntry.SetRange("Source Type",SourceType);
        ReservEntry.SetRange("Source Subtype",SourceSubType);
        ReservEntry.SetRange("Source Batch Name",'');
        if SourceType = Database::"Prod. Order Component" then begin
          ReservEntry.SetRange("Source Ref. No.",SourceSubLineNo);
          ReservEntry.SetRange("Source Prod. Order Line",SourceLineNo);
        end else begin
          ReservEntry.SetRange("Source Ref. No.",SourceLineNo);
          ReservEntry.SetRange("Source Prod. Order Line",0);
        end;
        ReservEntry.SetRange("Reservation Status",ReservEntry."reservation status"::Reservation);
        ReservEntry.SetFilter("Expected Receipt Date",'<>%1',0D);
        ReservEntry.SetFilter("Shipment Date",'<>%1',0D);
        if ReservEntry.Find('-') then
          repeat
            ReservQtyNotonInvt := ReservQtyNotonInvt + Abs(ReservEntry."Quantity (Base)");
          until ReservEntry.Next = 0;
        exit(ReservQtyNotonInvt);
    end;


    procedure GetCaption(DestType: Option " ",Customer,Vendor,Location,Item,Family,"Sales Order";SourceDoc: Option " ","Sales Order",,,"Sales Return Order","Purchase Order",,,"Purchase Return Order","Inbound Transfer","Outbound Transfer","Prod. Consumption","Prod. Output";Selection: Integer): Text[50]
    var
        PurchHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        Customer: Record Customer;
        Location: Record Location;
        Item: Record Item;
        Family: Record Family;
        SalesHeader: Record "Sales Header";
        WhseActivHdr: Record "Warehouse Activity Header";
    begin
        case Selection of
          0:
            case DestType of
              Desttype::Vendor:
                exit(Vendor.TableCaption + ' ' + Vendor.FieldCaption("No."));
              Desttype::Customer:
                exit(Customer.TableCaption + ' ' + Customer.FieldCaption("No."));
              Desttype::Location:
                exit(Location.TableCaption + ' ' + Location.FieldCaption(Code));
              Desttype::Item:
                exit(Item.TableCaption + ' ' + Item.FieldCaption("No."));
              Desttype::Family:
                exit(Family.TableCaption + ' ' + Family.FieldCaption("No."));
              Desttype::"Sales Order":
                exit(Text009 + ' ' + SalesHeader.FieldCaption("No."));
              else
                exit(WhseActivHdr.FieldCaption("Destination No."));
            end;
          1:
            case DestType of
              Desttype::Vendor:
                exit(Vendor.TableCaption + ' ' + Vendor.FieldCaption(Name));
              Desttype::Customer:
                exit(Customer.TableCaption + ' ' + Customer.FieldCaption(Name));
              Desttype::Location:
                exit(Location.TableCaption + ' ' + Location.FieldCaption(Name));
              Desttype::Item:
                exit(Item.TableCaption + ' ' + Item.FieldCaption(Description));
              Desttype::Family:
                exit(Family.TableCaption + ' ' + Family.FieldCaption(Description));
              Desttype::"Sales Order":
                exit(Text009 + ' ' + SalesHeader.FieldCaption("Sell-to Customer Name"));
              else
                exit(Text008);
            end;
          2:
            if SourceDoc in [
                             Sourcedoc::"Purchase Order",
                             Sourcedoc::"Purchase Return Order"]
            then
              exit(PurchHeader.FieldCaption("Vendor Shipment No."))
            else
              exit(WhseActivHdr.FieldCaption("External Document No."));
          3:
            case SourceDoc of
              Sourcedoc::"Purchase Order":
                exit(PurchHeader.FieldCaption("Vendor Invoice No."));
              Sourcedoc::"Purchase Return Order":
                exit(PurchHeader.FieldCaption("Vendor Cr. Memo No."));
              else
                exit(WhseActivHdr.FieldCaption("External Document No.2"));
            end;
        end;
    end;


    procedure GetDestinationName(DestType: Option " ",Customer,Vendor,Location,Item,Family,"Sales Order";DestNo: Code[20]): Text[50]
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        Location: Record Location;
        Item: Record Item;
        Family: Record Family;
        SalesHeader: Record "Sales Header";
    begin
        case DestType of
          Desttype::Customer:
            if Customer.Get(DestNo) then
              exit(Customer.Name);
          Desttype::Vendor:
            if Vendor.Get(DestNo) then
              exit(Vendor.Name);
          Desttype::Location:
            if Location.Get(DestNo) then
              exit(Location.Name);
          Desttype::Item:
            if Item.Get(DestNo) then
              exit(Item.Description);
          Desttype::Family:
            if Family.Get(DestNo) then
              exit(Family.Description);
          Desttype::"Sales Order":
            if SalesHeader.Get(SalesHeader."document type"::Order,DestNo) then
              exit(SalesHeader."Sell-to Customer Name");
        end;
    end;

    local procedure CalcReservEntryQuantity(WhseJnlLine: Record "Warehouse Journal Line"): Decimal
    var
        ReservEntry: Record "Reservation Entry";
    begin
        with WhseJnlLine do begin
          ReservEntry.SetCurrentkey(
            "Source ID","Source Ref. No.","Source Type","Source Subtype",
            "Source Batch Name","Source Prod. Order Line","Reservation Status");
          ReservEntry.SetRange("Source ID","Journal Template Name");
          ReservEntry.SetRange("Source Type","Source Type");
          ReservEntry.SetRange("Source Subtype","Source Subtype");
          ReservEntry.SetRange("Source Batch Name","Journal Batch Name");
          if "Source Type" = Database::"Prod. Order Component" then begin
            ReservEntry.SetRange("Source Ref. No.","Source Subline No.");
            ReservEntry.SetRange("Source Prod. Order Line","Source Line No.");
          end else begin
            ReservEntry.SetRange("Source Ref. No.","Source Line No.");
            ReservEntry.SetRange("Source Prod. Order Line",0);
          end;
          ReservEntry.SetRange("Serial No.","Serial No.");
          ReservEntry.SetRange("Lot No.","Lot No.");
          if ReservEntry.FindFirst then
            exit(ReservEntry."Quantity (Base)");
          exit("Qty. (Base)");
        end;
    end;


    procedure GetATOSalesLine(SourceType: Integer;SourceSubtype: Option;SourceID: Code[20];SourceRefNo: Integer;var SalesLine: Record "Sales Line"): Boolean
    begin
        if SourceType <> Database::"Sales Line" then
          exit(false);
        if SalesLine.Get(SourceSubtype,SourceID,SourceRefNo) then
          exit(SalesLine."Qty. to Asm. to Order (Base)" <> 0);
    end;

    local procedure SetFiltersOnATOInvtPick(SalesLine: Record "Sales Line";var WhseActivityLine: Record "Warehouse Activity Line")
    begin
        with WhseActivityLine do begin
          SetRange("Activity Type","activity type"::"Invt. Pick");
          SetRange("Source Type",Database::"Sales Line");
          SetRange("Source Subtype",SalesLine."Document Type");
          SetRange("Source No.",SalesLine."Document No.");
          SetRange("Source Line No.",SalesLine."Line No.");
          SetRange("Assemble to Order",true);
          if "Serial No." <> '' then
            SetRange("Serial No.","Serial No.");
          if "Lot No." <> '' then
            SetRange("Lot No.","Lot No.");
        end;
    end;


    procedure ATOInvtPickExists(SalesLine: Record "Sales Line"): Boolean
    var
        WhseActivityLine: Record "Warehouse Activity Line";
    begin
        SetFiltersOnATOInvtPick(SalesLine,WhseActivityLine);
        exit(not WhseActivityLine.IsEmpty);
    end;


    procedure CalcQtyBaseOnATOInvtPick(SalesLine: Record "Sales Line";SerialNo: Code[20];LotNo: Code[20]) QtyBase: Decimal
    var
        WhseActivityLine: Record "Warehouse Activity Line";
    begin
        WhseActivityLine."Serial No." := SerialNo;
        WhseActivityLine."Lot No." := LotNo;
        SetFiltersOnATOInvtPick(SalesLine,WhseActivityLine);
        if WhseActivityLine.FindSet then
          repeat
            QtyBase += WhseActivityLine."Qty. Outstanding (Base)";
          until WhseActivityLine.Next = 0;
    end;


    procedure CheckOutboundBlockedBin(LocationCode: Code[10];BinCode: Code[20];ItemNo: Code[20];VariantCode: Code[10];UnitOfMeasureCode: Code[10])
    begin
        CheckBlockedBin(LocationCode,BinCode,ItemNo,VariantCode,UnitOfMeasureCode,false);
    end;


    procedure CheckInboundBlockedBin(LocationCode: Code[10];BinCode: Code[20];ItemNo: Code[20];VariantCode: Code[10];UnitOfMeasureCode: Code[10])
    begin
        CheckBlockedBin(LocationCode,BinCode,ItemNo,VariantCode,UnitOfMeasureCode,true);
    end;

    local procedure SetFiltersOnATOWhseShpt(SalesLine: Record "Sales Line";var WhseShptLine: Record "Warehouse Shipment Line")
    begin
        with WhseShptLine do begin
          SetRange("Source Type",Database::"Sales Line");
          SetRange("Source Subtype",SalesLine."Document Type");
          SetRange("Source No.",SalesLine."Document No.");
          SetRange("Source Line No.",SalesLine."Line No.");
          SetRange("Assemble to Order",true);
        end;
    end;


    procedure ATOWhseShptExists(SalesLine: Record "Sales Line"): Boolean
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        SetFiltersOnATOWhseShpt(SalesLine,WhseShptLine);
        exit(not WhseShptLine.IsEmpty);
    end;

    local procedure CheckBlockedBin(LocationCode: Code[10];BinCode: Code[20];ItemNo: Code[20];VariantCode: Code[10];UnitOfMeasureCode: Code[10];CheckInbound: Boolean)
    var
        BinContent: Record "Bin Content";
    begin
        GetLocation(LocationCode);
        if Location."Directed Put-away and Pick" then
          if BinContent.Get(LocationCode,BinCode,ItemNo,VariantCode,UnitOfMeasureCode) then begin
            if (CheckInbound and
                (BinContent."Block Movement" in [BinContent."block movement"::Inbound,BinContent."block movement"::All])) or
               (not CheckInbound and
                (BinContent."Block Movement" in [BinContent."block movement"::Outbound,BinContent."block movement"::All]))
            then
              BinContent.FieldError("Block Movement");
          end else
            if Location."Bin Mandatory" then begin
              GetBin(LocationCode,BinCode);
              if (CheckInbound and (Bin."Block Movement" in [Bin."block movement"::Inbound,Bin."block movement"::All])) or
                 (not CheckInbound and (Bin."Block Movement" in [Bin."block movement"::Outbound,Bin."block movement"::All]))
              then
                Bin.FieldError("Block Movement");
            end;
    end;

    local procedure GetWhseJnlLineBinCode(SourceCode: Code[10];BinCode: Code[20];AdjBinCode: Code[20]): Code[20]
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        if BinCode = '' then
          exit(AdjBinCode);
        SourceCodeSetup.Get;
        if SourceCode = SourceCodeSetup."Service Management" then
          exit(BinCode);
        exit(AdjBinCode);
    end;


    procedure GetLastOperationFromBinCode(RoutingNo: Code[20];RoutingVersionCode: Code[20];LocationCode: Code[10];UseFlushingMethod: Boolean;FlushingMethod: Option Manual,Forward,Backward,"Pick + Forward","Pick + Backward"): Code[20]
    var
        RoutingLine: Record "Routing Line";
    begin
        with RoutingLine do begin
          SetRange("Routing No.",RoutingNo);
          SetRange("Version Code",RoutingVersionCode);
          if FindLast then
            exit(GetProdCenterBinCode(Type,"No.",LocationCode,UseFlushingMethod,FlushingMethod));
        end;
    end;


    procedure GetProdRtngLastOperationFromBinCode(ProdOrderStatus: Option;ProdOrderNo: Code[20];RoutingRefNo: Integer;RoutingNo: Code[20];LocationCode: Code[10]): Code[20]
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        with ProdOrderRoutingLine do begin
          SetRange(Status,ProdOrderStatus);
          SetRange("Prod. Order No.",ProdOrderNo);
          SetRange("Routing Reference No.",RoutingRefNo);
          SetRange("Routing No.",RoutingNo);
          if FindLast then
            exit(GetProdCenterBinCode(Type,"No.",LocationCode,false,0));
        end;
    end;


    procedure GetPlanningRtngLastOperationFromBinCode(WkshTemplateName: Code[10];WkshBatchName: Code[10];WkshLineNo: Integer;LocationCode: Code[10]): Code[20]
    var
        PlanningRoutingLine: Record "Planning Routing Line";
    begin
        with PlanningRoutingLine do begin
          SetRange("Worksheet Template Name",WkshTemplateName);
          SetRange("Worksheet Batch Name",WkshBatchName);
          SetRange("Worksheet Line No.",WkshLineNo);
          if FindLast then
            exit(GetProdCenterBinCode(Type,"No.",LocationCode,false,0));
        end;
    end;


    procedure GetProdCenterBinCode(Type: Option "Work Center","Machine Center";No: Code[20];LocationCode: Code[10];UseFlushingMethod: Boolean;FlushingMethod: Option Manual,Forward,Backward,"Pick + Forward","Pick + Backward"): Code[20]
    begin
        case Type of
          Type::"Work Center":
            exit(GetWorkCenterBinCode(No,LocationCode,UseFlushingMethod,FlushingMethod));
          Type::"Machine Center":
            exit(GetMachineCenterBinCode(No,LocationCode,UseFlushingMethod,FlushingMethod));
        end;
    end;

    local procedure GetMachineCenterBinCode(MachineCenterNo: Code[20];LocationCode: Code[10];UseFlushingMethod: Boolean;FlushingMethod: Option Manual,Forward,Backward,"Pick + Forward","Pick + Backward"): Code[20]
    var
        MachineCenter: Record "Machine Center";
    begin
        if MachineCenter.Get(MachineCenterNo) then begin
          if (MachineCenter."Location Code" = LocationCode) and
             (MachineCenter."From-Production Bin Code" <> '')
          then
            exit(MachineCenter.GetBinCode(UseFlushingMethod,FlushingMethod));

          exit(GetWorkCenterBinCode(MachineCenter."Work Center No.",LocationCode,UseFlushingMethod,FlushingMethod));
        end;
    end;

    local procedure GetWorkCenterBinCode(WorkCenterNo: Code[20];LocationCode: Code[10];UseFlushingMethod: Boolean;FlushingMethod: Option Manual,Forward,Backward,"Pick + Forward","Pick + Backward"): Code[20]
    var
        WorkCenter: Record "Work Center";
    begin
        if WorkCenter.Get(WorkCenterNo) then
          if WorkCenter."Location Code" = LocationCode then
            exit(WorkCenter.GetBinCode(UseFlushingMethod,FlushingMethod));
    end;

    local procedure xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx()
    begin
    end;


    procedure GetATOSalesLine2(SourceType: Integer;SourceSubtype: Option;SourceID: Code[20];SourceRefNo: Integer;var SalesLine: Record "Sales Line"): Boolean
    begin
        if SourceType <> Database::"Sales Line" then
          exit(false);
        if SalesLine.Get(SourceSubtype,SourceID,SourceRefNo) then
          exit(SalesLine."Qty. to Asm. to Order (Base)" <> 0);
    end;


    procedure ATOWhseShptExists2(SalesLine: Record "Sales Line"): Boolean
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        SetFiltersOnATOWhseShpt2(SalesLine,WhseShptLine);
        exit(not WhseShptLine.IsEmpty);
    end;

    local procedure SetFiltersOnATOInvtPick2(SalesLine: Record "Sales Line";var WhseActivityLine: Record "Warehouse Activity Line")
    begin
        with WhseActivityLine do begin
          SetRange("Activity Type","activity type"::"Invt. Pick");
          SetRange("Source Type",Database::"Sales Line");
          SetRange("Source Subtype",SalesLine."Document Type");
          SetRange("Source No.",SalesLine."Document No.");
          SetRange("Source Line No.",SalesLine."Line No.");
          SetRange("Assemble to Order",true);
          if "Serial No." <> '' then
            SetRange("Serial No.","Serial No.");
          if "Lot No." <> '' then
            SetRange("Lot No.","Lot No.");
        end;
    end;

    local procedure SetFiltersOnATOWhseShpt2(SalesLine: Record "Sales Line";var WhseShptLine: Record "Warehouse Shipment Line")
    begin
        with WhseShptLine do begin
          SetRange("Source Type",Database::"Sales Line");
          SetRange("Source Subtype",SalesLine."Document Type");
          SetRange("Source No.",SalesLine."Document No.");
          SetRange("Source Line No.",SalesLine."Line No.");
          SetRange("Assemble to Order",true);
        end;
    end;
}

