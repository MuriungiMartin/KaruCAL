#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 23 "Item Jnl.-Post Batch"
{
    Permissions = TableData "Item Journal Batch"=imd,
                  TableData "Warehouse Register"=r;
    TableNo = "Item Journal Line";

    trigger OnRun()
    begin
        ItemJnlLine.Copy(Rec);
        Code;
        Rec := ItemJnlLine;
    end;

    var
        Text000: label 'cannot exceed %1 characters';
        Text001: label 'Journal Batch Name    #1##########\\';
        Text002: label 'Checking lines        #2######\';
        Text003: label 'Posting lines         #3###### @4@@@@@@@@@@@@@\';
        Text004: label 'Updating lines        #5###### @6@@@@@@@@@@@@@';
        Text005: label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: label 'A maximum of %1 posting number series can be used in each journal.';
        Text007: label '<Month Text>';
        Text008: label 'There are new postings made in the period you want to revalue item no. %1.\';
        Text009: label 'You must calculate the inventory value again.';
        Text010: label 'One or more reservation entries exist for the item with %1 = %2, %3 = %4, %5 = %6 which may be disrupted if you post this negative adjustment. Do you want to continue?', Comment='One or more reservation entries exist for the item with Item No. = 1000, Location Code = BLUE, Variant Code = NEW which may be disrupted if you post this negative adjustment. Do you want to continue?';
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlLine: Record "Item Journal Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        WhseEntry: Record "Warehouse Entry";
        ItemReg: Record "Item Register";
        WhseReg: Record "Warehouse Register";
        GLSetup: Record "General Ledger Setup";
        InvtSetup: Record "Inventory Setup";
        AccountingPeriod: Record "Accounting Period";
        NoSeries: Record "No. Series" temporary;
        Location: Record Location;
        ItemJnlCheckLine: Codeunit "Item Jnl.-Check Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesMgt2: array [10] of Codeunit NoSeriesManagement;
        WMSMgmt: Codeunit "WMS Management";
        WhseJnlPostLine: Codeunit "Whse. Jnl.-Register Line";
        InvtAdjmt: Codeunit "Inventory Adjustment";
        Window: Dialog;
        ItemRegNo: Integer;
        WhseRegNo: Integer;
        StartLineNo: Integer;
        Day: Integer;
        Week: Integer;
        Month: Integer;
        MonthText: Text[30];
        NoOfRecords: Integer;
        LineCount: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;
        WhseTransaction: Boolean;
        PhysInvtCount: Boolean;

    local procedure "Code"()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
        OldEntryType: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
    begin
        with ItemJnlLine do begin
          LockTable;
          SetRange("Journal Template Name","Journal Template Name");
          SetRange("Journal Batch Name","Journal Batch Name");

          ItemJnlTemplate.Get("Journal Template Name");
          ItemJnlBatch.Get("Journal Template Name","Journal Batch Name");
          if StrLen(IncStr(ItemJnlBatch.Name)) > MaxStrLen(ItemJnlBatch.Name) then
            ItemJnlBatch.FieldError(
              Name,
              StrSubstNo(
                Text000,
                MaxStrLen(ItemJnlBatch.Name)));

          if ItemJnlTemplate.Recurring then begin
            SetRange("Posting Date",0D,WorkDate);
            SetFilter("Expiration Date",'%1 | %2..',0D,WorkDate);
          end;

          if not Find('=><') then begin
            "Line No." := 0;
            Commit;
            exit;
          end;

          CheckItemAvailability(ItemJnlLine);

          if ItemJnlTemplate.Recurring then
            Window.Open(
              Text001 +
              Text002 +
              Text003 +
              Text004)
          else
            Window.Open(
              Text001 +
              Text002 +
              Text005);

          Window.Update(1,"Journal Batch Name");

          CheckLines(ItemJnlLine);

          // Find next register no.
          ItemLedgEntry.LockTable;
          if ItemLedgEntry.FindLast then;
          if WhseTransaction then begin
            WhseEntry.LockTable;
            if WhseEntry.FindLast then;
          end;

          ItemReg.LockTable;
          if ItemReg.FindLast then
            ItemRegNo := ItemReg."No." + 1
          else
            ItemRegNo := 1;

          WhseReg.LockTable;
          if WhseReg.FindLast then
            WhseRegNo := WhseReg."No." + 1
          else
            WhseRegNo := 1;

          GLSetup.Get;
          PhysInvtCount := false;

          // Post lines
          LineCount := 0;
          OldEntryType := "Entry Type";
          PostLines(ItemJnlLine,PhysInvtCountMgt);

          // Copy register no. and current journal batch name to item journal
          if not ItemReg.FindLast or (ItemReg."No." <> ItemRegNo) then
            ItemRegNo := 0;
          if not WhseReg.FindLast or (WhseReg."No." <> WhseRegNo) then
            WhseRegNo := 0;

          Init;

          "Line No." := ItemRegNo;
          if "Line No." = 0 then
            "Line No." := WhseRegNo;

          InvtSetup.Get;
          if InvtSetup."Automatic Cost Adjustment" <>
             InvtSetup."automatic cost adjustment"::Never
          then begin
            InvtAdjmt.SetProperties(true,InvtSetup."Automatic Cost Posting");
            InvtAdjmt.MakeMultiLevelAdjmt;
          end;

          // Update/delete lines
          if "Line No." <> 0 then begin
            if ItemJnlTemplate.Recurring then begin
              HandleRecurringLine(ItemJnlLine);
            end else
              HandleNonRecurringLine(ItemJnlLine,OldEntryType);
            if ItemJnlBatch."No. Series" <> '' then
              NoSeriesMgt.SaveNoSeries;
            if NoSeries.FindSet then
              repeat
                Evaluate(PostingNoSeriesNo,NoSeries.Description);
                NoSeriesMgt2[PostingNoSeriesNo].SaveNoSeries;
              until NoSeries.Next = 0;
          end;

          if PhysInvtCount then
            PhysInvtCountMgt.UpdateItemSKUListPhysInvtCount;

          Window.Close;
          Commit;
          Clear(ItemJnlCheckLine);
          Clear(ItemJnlPostLine);
          Clear(WhseJnlPostLine);
          Clear(InvtAdjmt)
        end;
        UpdateAnalysisView.UpdateAll(0,true);
        UpdateItemAnalysisView.UpdateAll(0,true);
        Commit;
    end;

    local procedure CheckLines(var ItemJnlLine: Record "Item Journal Line")
    begin
        with ItemJnlLine do begin
          LineCount := 0;
          StartLineNo := "Line No.";
          repeat
            LineCount := LineCount + 1;
            Window.Update(2,LineCount);
            CheckRecurringLine(ItemJnlLine);

            if (("Value Entry Type" = "value entry type"::"Direct Cost") and ("Item Charge No." = '')) or
               (("Invoiced Quantity" <> 0) and (Amount <> 0))
            then begin
              ItemJnlCheckLine.RunCheck(ItemJnlLine);

              if (Quantity <> 0) and
                 ("Value Entry Type" = "value entry type"::"Direct Cost") and
                 ("Item Charge No." = '')
              then
                CheckWMSBin(ItemJnlLine);

              if ("Value Entry Type" = "value entry type"::Revaluation) and
                 ("Inventory Value Per" = "inventory value per"::" ") and
                 "Partial Revaluation"
              then
                CheckRemainingQty;
            end;

            if Next = 0 then
              FindFirst;
          until "Line No." = StartLineNo;
          NoOfRecords := LineCount;
        end;
    end;

    local procedure PostLines(var ItemJnlLine: Record "Item Journal Line";var PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management")
    var
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        OriginalQuantity: Decimal;
        OriginalQuantityBase: Decimal;
    begin
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        with ItemJnlLine do begin
          FindSet;
          repeat
            if not EmptyLine and
               (ItemJnlBatch."No. Series" <> '') and
               ("Document No." <> LastDocNo2)
            then
              TestField("Document No.",NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series","Posting Date",false));
            if not EmptyLine then
              LastDocNo2 := "Document No.";
            MakeRecurringTexts(ItemJnlLine);
            ConstructPostingNumber(ItemJnlLine);

            if "Inventory Value Per" <> "inventory value per"::" " then
              ItemJnlPostSumLine(ItemJnlLine)
            else
              if (("Value Entry Type" = "value entry type"::"Direct Cost") and ("Item Charge No." = '')) or
                 (("Invoiced Quantity" <> 0) and (Amount <> 0))
              then begin
                LineCount := LineCount + 1;
                Window.Update(3,LineCount);
                Window.Update(4,ROUND(LineCount / NoOfRecords * 10000,1));
                OriginalQuantity := Quantity;
                OriginalQuantityBase := "Quantity (Base)";
                if not ItemJnlPostLine.RunWithCheck(ItemJnlLine) then
                  ItemJnlPostLine.CheckItemTracking;
                if "Value Entry Type" <> "value entry type"::Revaluation then begin
                  ItemJnlPostLine.CollectTrackingSpecification(TempTrackingSpecification);
                  PostWhseJnlLine(ItemJnlLine,OriginalQuantity,OriginalQuantityBase,TempTrackingSpecification);
                end;
              end;

            if IsPhysInvtCount(ItemJnlTemplate,"Phys Invt Counting Period Code","Phys Invt Counting Period Type") then begin
              if not PhysInvtCount then begin
                PhysInvtCountMgt.InitTempItemSKUList;
                PhysInvtCount := true;
              end;
              PhysInvtCountMgt.AddToTempItemSKUList("Item No.","Location Code","Variant Code","Phys Invt Counting Period Type");
            end;
          until Next = 0;
        end;
    end;

    local procedure HandleRecurringLine(var ItemJnlLine: Record "Item Journal Line")
    var
        ItemJnlLine2: Record "Item Journal Line";
    begin
        LineCount := 0;
        ItemJnlLine2.CopyFilters(ItemJnlLine);
        ItemJnlLine2.FindSet;
        repeat
          LineCount := LineCount + 1;
          Window.Update(5,LineCount);
          Window.Update(6,ROUND(LineCount / NoOfRecords * 10000,1));
          if ItemJnlLine2."Posting Date" <> 0D then
            ItemJnlLine2.Validate("Posting Date",CalcDate(ItemJnlLine2."Recurring Frequency",ItemJnlLine2."Posting Date"));
          if (ItemJnlLine2."Recurring Method" = ItemJnlLine2."recurring method"::Variable) and
             (ItemJnlLine2."Item No." <> '')
          then begin
            ItemJnlLine2.Quantity := 0;
            ItemJnlLine2."Invoiced Quantity" := 0;
            ItemJnlLine2.Amount := 0;
          end;
          ItemJnlLine2.Modify;
        until ItemJnlLine2.Next = 0;
    end;

    local procedure HandleNonRecurringLine(var ItemJnlLine: Record "Item Journal Line";OldEntryType: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output")
    var
        ItemJnlLine2: Record "Item Journal Line";
        ItemJnlLine3: Record "Item Journal Line";
    begin
        with ItemJnlLine do begin
          ItemJnlLine2.CopyFilters(ItemJnlLine);
          ItemJnlLine2.SetFilter("Item No.",'<>%1','');
          if ItemJnlLine2.FindLast then; // Remember the last line
          ItemJnlLine2."Entry Type" := OldEntryType;

          ItemJnlLine3.Copy(ItemJnlLine);
          ItemJnlLine3.DeleteAll;
          ItemJnlLine3.Reset;
          ItemJnlLine3.SetRange("Journal Template Name","Journal Template Name");
          ItemJnlLine3.SetRange("Journal Batch Name","Journal Batch Name");
          if not ItemJnlLine3.FindLast then
            if IncStr("Journal Batch Name") <> '' then begin
              ItemJnlBatch.Delete;
              ItemJnlBatch.Name := IncStr("Journal Batch Name");
              if ItemJnlBatch.Insert then;
              "Journal Batch Name" := ItemJnlBatch.Name;
            end;

          ItemJnlLine3.SetRange("Journal Batch Name","Journal Batch Name");
          if (ItemJnlBatch."No. Series" = '') and not ItemJnlLine3.FindLast and
             not (ItemJnlLine2."Entry Type" in [ItemJnlLine2."entry type"::Consumption,ItemJnlLine2."entry type"::Output])
          then begin
            ItemJnlLine3.Init;
            ItemJnlLine3."Journal Template Name" := "Journal Template Name";
            ItemJnlLine3."Journal Batch Name" := "Journal Batch Name";
            ItemJnlLine3."Line No." := 10000;
            ItemJnlLine3.Insert;
            ItemJnlLine3.SetUpNewLine(ItemJnlLine2);
            ItemJnlLine3.Modify;
          end;
        end;
    end;

    local procedure ConstructPostingNumber(var ItemJnlLine: Record "Item Journal Line")
    begin
        with ItemJnlLine do begin
          if "Posting No. Series" = '' then
            "Posting No. Series" := ItemJnlBatch."No. Series"
          else
            if not EmptyLine then
              if "Document No." = LastDocNo then
                "Document No." := LastPostedDocNo
              else begin
                if not NoSeries.Get("Posting No. Series") then begin
                  NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                  if NoOfPostingNoSeries > ArrayLen(NoSeriesMgt2) then
                    Error(
                      Text006,
                      ArrayLen(NoSeriesMgt2));
                  NoSeries.Code := "Posting No. Series";
                  NoSeries.Description := Format(NoOfPostingNoSeries);
                  NoSeries.Insert;
                end;
                LastDocNo := "Document No.";
                Evaluate(PostingNoSeriesNo,NoSeries.Description);
                "Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series","Posting Date",false);
                LastPostedDocNo := "Document No.";
              end;
        end;
    end;

    local procedure CheckRecurringLine(var ItemJnlLine2: Record "Item Journal Line")
    var
        NULDF: DateFormula;
    begin
        with ItemJnlLine2 do begin
          if "Item No." <> '' then
            if ItemJnlTemplate.Recurring then begin
              TestField("Recurring Method");
              TestField("Recurring Frequency");
              if "Recurring Method" = "recurring method"::Variable then
                TestField(Quantity);
            end else begin
              Clear(NULDF);
              TestField("Recurring Method",0);
              TestField("Recurring Frequency",NULDF);
            end;
        end;
    end;

    local procedure MakeRecurringTexts(var ItemJnlLine2: Record "Item Journal Line")
    begin
        with ItemJnlLine2 do begin
          if ("Item No." <> '') and ("Recurring Method" <> 0) then begin // Not recurring
            Day := Date2dmy("Posting Date",1);
            Week := Date2dwy("Posting Date",2);
            Month := Date2dmy("Posting Date",2);
            MonthText := Format("Posting Date",0,Text007);
            AccountingPeriod.SetRange("Starting Date",0D,"Posting Date");
            if not AccountingPeriod.FindLast then
              AccountingPeriod.Name := '';
            "Document No." :=
              DelChr(
                PadStr(
                  StrSubstNo("Document No.",Day,Week,Month,MonthText,AccountingPeriod.Name),
                  MaxStrLen("Document No.")),
                '>');
            Description :=
              DelChr(
                PadStr(
                  StrSubstNo(Description,Day,Week,Month,MonthText,AccountingPeriod.Name),
                  MaxStrLen(Description)),
                '>');
          end;
        end;
    end;

    local procedure ItemJnlPostSumLine(ItemJnlLine4: Record "Item Journal Line")
    var
        Item: Record Item;
        ItemLedgEntry4: Record "Item Ledger Entry";
        ItemLedgEntry5: Record "Item Ledger Entry";
        Remainder: Decimal;
        RemAmountToDistribute: Decimal;
        RemQuantity: Decimal;
        DistributeCosts: Boolean;
        IncludeExpectedCost: Boolean;
        PostingDate: Date;
        IsLastEntry: Boolean;
    begin
        DistributeCosts := true;
        RemAmountToDistribute := ItemJnlLine.Amount;
        RemQuantity := ItemJnlLine.Quantity;
        if ItemJnlLine.Amount <> 0 then begin
          LineCount := LineCount + 1;
          Window.Update(3,LineCount);
          Window.Update(4,ROUND(LineCount / NoOfRecords * 10000,1));
          with ItemLedgEntry4 do begin
            Item.Get(ItemJnlLine4."Item No.");
            IncludeExpectedCost := (Item."Costing Method" = Item."costing method"::Standard) and
              (ItemJnlLine4."Inventory Value Per" <> ItemJnlLine4."inventory value per"::" ");
            Reset;
            SetCurrentkey("Item No.",Positive,"Location Code","Variant Code");
            SetRange("Item No.",ItemJnlLine."Item No.");
            SetRange(Positive,true);
            PostingDate := ItemJnlLine."Posting Date";

            if (ItemJnlLine4."Location Code" <> '') or
               (ItemJnlLine4."Inventory Value Per" in
                [ItemJnlLine."inventory value per"::Location,
                 ItemJnlLine4."inventory value per"::"Location and Variant"])
            then
              SetRange("Location Code",ItemJnlLine."Location Code");
            if (ItemJnlLine."Variant Code" <> '') or
               (ItemJnlLine4."Inventory Value Per" in
                [ItemJnlLine."inventory value per"::Variant,
                 ItemJnlLine4."inventory value per"::"Location and Variant"])
            then
              SetRange("Variant Code",ItemJnlLine."Variant Code");
            if FindSet then
              repeat
                if IncludeEntryInCalc(ItemLedgEntry4,PostingDate,IncludeExpectedCost) then begin
                  ItemLedgEntry5 := ItemLedgEntry4;

                  ItemJnlLine4."Entry Type" := "Entry Type";
                  if "Remaining Quantity" <> Quantity then
                    ItemJnlLine4.Quantity :=
                      CalculateRemQuantity("Entry No.",ItemJnlLine."Posting Date")
                  else
                    ItemJnlLine4.Quantity := Quantity;

                  ItemJnlLine4."Quantity (Base)" := ItemJnlLine4.Quantity;
                  ItemJnlLine4."Invoiced Quantity" := ItemJnlLine4.Quantity;
                  ItemJnlLine4."Invoiced Qty. (Base)" := ItemJnlLine4.Quantity;
                  ItemJnlLine4."Location Code" := "Location Code";
                  ItemJnlLine4."Variant Code" := "Variant Code";
                  ItemJnlLine4."Applies-to Entry" := "Entry No.";
                  ItemJnlLine4."Source No." := "Source No.";
                  ItemJnlLine4."Order Type" := "Order Type";
                  ItemJnlLine4."Order No." := "Order No.";
                  ItemJnlLine4."Order Line No." := "Order Line No.";

                  if ItemJnlLine4.Quantity <> 0 then begin
                    ItemJnlLine4.Amount :=
                      ItemJnlLine."Inventory Value (Revalued)" * ItemJnlLine4.Quantity /
                      ItemJnlLine.Quantity -
                      ROUND(
                        CalculateRemInventoryValue(
                          "Entry No.",Quantity,ItemJnlLine4.Quantity,
                          IncludeExpectedCost and not "Completely Invoiced",PostingDate),
                        GLSetup."Amount Rounding Precision") + Remainder;

                    RemQuantity := RemQuantity - ItemJnlLine4.Quantity;

                    if RemQuantity = 0 then begin
                      if Next > 0 then
                        repeat
                          if IncludeEntryInCalc(ItemLedgEntry4,PostingDate,IncludeExpectedCost) then begin
                            RemQuantity := CalculateRemQuantity("Entry No.",ItemJnlLine."Posting Date");
                            if RemQuantity > 0 then
                              Error(Text008 + Text009,ItemJnlLine4."Item No.");
                          end;
                        until Next = 0;

                      ItemJnlLine4.Amount := RemAmountToDistribute;
                      DistributeCosts := false;
                    end else begin
                      repeat
                        IsLastEntry := Next = 0;
                      until IncludeEntryInCalc(ItemLedgEntry4,PostingDate,IncludeExpectedCost) or IsLastEntry;
                      if IsLastEntry or (RemQuantity < 0) then
                        Error(Text008 + Text009,ItemJnlLine4."Item No.");
                      Remainder := ItemJnlLine4.Amount - ROUND(ItemJnlLine4.Amount,GLSetup."Amount Rounding Precision");
                      ItemJnlLine4.Amount := ROUND(ItemJnlLine4.Amount,GLSetup."Amount Rounding Precision");
                      RemAmountToDistribute := RemAmountToDistribute - ItemJnlLine4.Amount;
                    end;
                    ItemJnlLine4."Unit Cost" := ItemJnlLine4.Amount / ItemJnlLine4.Quantity;

                    if ItemJnlLine4.Amount <> 0 then begin
                      if IncludeExpectedCost and not ItemLedgEntry5."Completely Invoiced" then begin
                        ItemJnlLine4."Applied Amount" := ROUND(
                            ItemJnlLine4.Amount * (ItemLedgEntry5.Quantity - ItemLedgEntry5."Invoiced Quantity") /
                            ItemLedgEntry5.Quantity,
                            GLSetup."Amount Rounding Precision");
                      end else
                        ItemJnlLine4."Applied Amount" := 0;
                      ItemJnlPostLine.RunWithCheck(ItemJnlLine4);
                    end;
                  end else begin
                    repeat
                      IsLastEntry := Next = 0;
                    until IncludeEntryInCalc(ItemLedgEntry4,PostingDate,IncludeExpectedCost) or IsLastEntry;
                    if IsLastEntry then
                      Error(Text008 + Text009,ItemJnlLine4."Item No.");
                  end;
                end else
                  DistributeCosts := Next <> 0;
              until not DistributeCosts;
          end;

          if ItemJnlLine."Update Standard Cost" then
            UpdateStdCost;
        end;
    end;

    local procedure IncludeEntryInCalc(ItemLedgEntry: Record "Item Ledger Entry";PostingDate: Date;IncludeExpectedCost: Boolean): Boolean
    begin
        with ItemLedgEntry do begin
          if IncludeExpectedCost then
            exit("Posting Date" in [0D..PostingDate]);
          exit("Completely Invoiced" and ("Last Invoice Date" in [0D..PostingDate]));
        end;
    end;

    local procedure UpdateStdCost()
    var
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
    begin
        with ItemJnlLine do begin
          if SKU.Get("Location Code","Item No.","Variant Code") then begin
            SKU.Validate("Standard Cost","Unit Cost (Revalued)");
            SKU.Modify;
          end else begin
            Item.Get("Item No.");
            Item.Validate("Standard Cost","Unit Cost (Revalued)");
            Item."Single-Level Material Cost" := "Single-Level Material Cost";
            Item."Single-Level Capacity Cost" := "Single-Level Capacity Cost";
            Item."Single-Level Subcontrd. Cost" := "Single-Level Subcontrd. Cost";
            Item."Single-Level Cap. Ovhd Cost" := "Single-Level Cap. Ovhd Cost";
            Item."Single-Level Mfg. Ovhd Cost" := "Single-Level Mfg. Ovhd Cost";
            Item."Rolled-up Material Cost" := "Rolled-up Material Cost";
            Item."Rolled-up Capacity Cost" := "Rolled-up Capacity Cost";
            Item."Rolled-up Subcontracted Cost" := "Rolled-up Subcontracted Cost";
            Item."Rolled-up Mfg. Ovhd Cost" := "Rolled-up Mfg. Ovhd Cost";
            Item."Rolled-up Cap. Overhead Cost" := "Rolled-up Cap. Overhead Cost";
            Item."Last Unit Cost Calc. Date" := "Posting Date";
            Item.Modify;
          end;
        end;
    end;

    local procedure CheckRemainingQty()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        RemainingQty: Decimal;
    begin
        RemainingQty := ItemLedgerEntry.CalculateRemQuantity(
            ItemJnlLine."Applies-to Entry",ItemJnlLine."Posting Date");

        if RemainingQty <> ItemJnlLine.Quantity then
          Error(Text008 + Text009,ItemJnlLine."Item No.");
    end;

    local procedure PostWhseJnlLine(ItemJnlLine: Record "Item Journal Line";OriginalQuantity: Decimal;OriginalQuantityBase: Decimal;var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        WhseJnlLine: Record "Warehouse Journal Line";
        TempWhseJnlLine2: Record "Warehouse Journal Line" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        with ItemJnlLine do begin
          Quantity := OriginalQuantity;
          "Quantity (Base)" := OriginalQuantityBase;
          GetLocation("Location Code");
          if not ("Entry Type" in ["entry type"::Consumption,"entry type"::Output]) then
            if Location."Bin Mandatory" then
              if WMSMgmt.CreateWhseJnlLine(ItemJnlLine,ItemJnlTemplate.Type,WhseJnlLine,false) then begin
                ItemTrackingMgt.SplitWhseJnlLine(WhseJnlLine,TempWhseJnlLine2,TempTrackingSpecification,false);
                if TempWhseJnlLine2.FindSet then
                  repeat
                    WMSMgmt.CheckWhseJnlLine(TempWhseJnlLine2,1,0,false);
                    WhseJnlPostLine.Run(TempWhseJnlLine2);
                  until TempWhseJnlLine2.Next = 0;
              end;

          if "Entry Type" = "entry type"::Transfer then begin
            GetLocation("New Location Code");
            if Location."Bin Mandatory" then
              if WMSMgmt.CreateWhseJnlLine(ItemJnlLine,ItemJnlTemplate.Type,WhseJnlLine,true) then begin
                ItemTrackingMgt.SplitWhseJnlLine(WhseJnlLine,TempWhseJnlLine2,TempTrackingSpecification,true);
                if TempWhseJnlLine2.FindSet then
                  repeat
                    WMSMgmt.CheckWhseJnlLine(TempWhseJnlLine2,1,0,true);
                    WhseJnlPostLine.Run(TempWhseJnlLine2);
                  until TempWhseJnlLine2.Next = 0;
              end;
          end;
        end;
    end;

    local procedure CheckWMSBin(ItemJnlLine: Record "Item Journal Line")
    begin
        with ItemJnlLine do begin
          GetLocation("Location Code");
          if Location."Bin Mandatory" then
            WhseTransaction := true;
          case "Entry Type" of
            "entry type"::Purchase,"entry type"::Sale,
            "entry type"::"Positive Adjmt.","entry type"::"Negative Adjmt.":
              begin
                if Location."Directed Put-away and Pick" then
                  WMSMgmt.CheckAdjmtBin(
                    Location,Quantity,
                    ("Entry Type" in
                     ["entry type"::Purchase,
                      "entry type"::"Positive Adjmt."]));
              end;
            "entry type"::Transfer:
              begin
                if Location."Directed Put-away and Pick" then
                  WMSMgmt.CheckAdjmtBin(Location,-Quantity,false);
                GetLocation("New Location Code");
                if Location."Directed Put-away and Pick" then
                  WMSMgmt.CheckAdjmtBin(Location,Quantity,true);
                if Location."Bin Mandatory" then
                  WhseTransaction := true;
              end;
          end;
        end;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Clear(Location)
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;


    procedure GetWhseRegNo(): Integer
    begin
        exit(WhseRegNo);
    end;


    procedure GetItemRegNo(): Integer
    begin
        exit(ItemRegNo);
    end;

    local procedure IsPhysInvtCount(ItemJnlTemplate2: Record "Item Journal Template";PhysInvtCountingPeriodCode: Code[10];PhysInvtCountingPeriodType: Option " ",Item,SKU): Boolean
    begin
        exit(
          (ItemJnlTemplate2.Type = ItemJnlTemplate2.Type::"Phys. Inventory") and
          (PhysInvtCountingPeriodType <> Physinvtcountingperiodtype::" ") and
          (PhysInvtCountingPeriodCode <> ''));
    end;

    local procedure CheckItemAvailability(var ItemJnlLine: Record "Item Journal Line")
    var
        Item: Record Item;
        TempSKU: Record "Stockkeeping Unit" temporary;
        ItemJnlLine2: Record "Item Journal Line";
        QtyinItemJnlLine: Decimal;
        AvailableQty: Decimal;
    begin
        ItemJnlLine2.CopyFilters(ItemJnlLine);
        if ItemJnlLine2.FindSet then
          repeat
            if not TempSKU.Get(ItemJnlLine2."Location Code",ItemJnlLine2."Item No.",ItemJnlLine2."Variant Code") then
              InsertTempSKU(TempSKU,ItemJnlLine2);
          until ItemJnlLine2.Next = 0;

        if TempSKU.FindSet then
          repeat
            QtyinItemJnlLine := CalcRequiredQty(TempSKU,ItemJnlLine2);
            if QtyinItemJnlLine < 0 then begin
              Item.Get(TempSKU."Item No.");
              Item.SetFilter("Location Filter",TempSKU."Location Code");
              Item.SetFilter("Variant Filter",TempSKU."Variant Code");
              Item.CalcFields("Reserved Qty. on Inventory","Net Change");
              AvailableQty := Item."Net Change" - Item."Reserved Qty. on Inventory" + SelfReservedQty(TempSKU,ItemJnlLine2);

              if (Item."Reserved Qty. on Inventory" > 0) and (AvailableQty < Abs(QtyinItemJnlLine)) then
                if not Confirm(
                     Text010,false,TempSKU.FieldCaption("Item No."),TempSKU."Item No.",TempSKU.FieldCaption("Location Code"),
                     TempSKU."Location Code",TempSKU.FieldCaption("Variant Code"),TempSKU."Variant Code")
                then
                  Error('');
            end;
          until TempSKU.Next = 0 ;
    end;

    local procedure InsertTempSKU(var TempSKU: Record "Stockkeeping Unit" temporary;ItemJnlLine: Record "Item Journal Line")
    begin
        with TempSKU do begin
          Init;
          "Location Code" := ItemJnlLine."Location Code";
          "Item No." := ItemJnlLine."Item No.";
          "Variant Code" := ItemJnlLine."Variant Code";
          Insert;
        end;
    end;

    local procedure CalcRequiredQty(TempSKU: Record "Stockkeeping Unit" temporary;var ItemJnlLine: Record "Item Journal Line"): Decimal
    var
        SignFactor: Integer;
        QtyinItemJnlLine: Decimal;
    begin
        QtyinItemJnlLine := 0;
        ItemJnlLine.SetRange("Item No.",TempSKU."Item No.");
        ItemJnlLine.SetRange("Location Code",TempSKU."Location Code");
        ItemJnlLine.SetRange("Variant Code",TempSKU."Variant Code");
        ItemJnlLine.FindSet;
        repeat
          if (ItemJnlLine."Entry Type" in
              [ItemJnlLine."entry type"::Sale,
               ItemJnlLine."entry type"::"Negative Adjmt.",
               ItemJnlLine."entry type"::Consumption]) or
             (ItemJnlLine."Entry Type" = ItemJnlLine."entry type"::Transfer)
          then
            SignFactor := -1
          else
            SignFactor := 1;
          QtyinItemJnlLine += ItemJnlLine."Quantity (Base)" * SignFactor;
        until ItemJnlLine.Next = 0;
        exit(QtyinItemJnlLine);
    end;

    local procedure SelfReservedQty(SKU: Record "Stockkeeping Unit";ItemJnlLine: Record "Item Journal Line"): Decimal
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        if ItemJnlLine."Order Type" <> ItemJnlLine."order type"::Production then
          exit;

        with ReservationEntry do begin
          SetRange("Item No.",SKU."Item No.");
          SetRange("Location Code",SKU."Location Code");
          SetRange("Variant Code",SKU."Variant Code");
          SetRange("Source Type",Database::"Prod. Order Component");
          SetRange("Source ID",ItemJnlLine."Order No.");
          if IsEmpty then
            exit;
          CalcSums("Quantity (Base)");
          exit(-"Quantity (Base)");
        end;
    end;
}

