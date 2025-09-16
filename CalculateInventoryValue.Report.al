#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5899 "Calculate Inventory Value"
{
    Caption = 'Calculate Inventory Value';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.") where(Type=const(Inventory));
            RequestFilterFields = "No.","Costing Method","Location Filter","Variant Filter";
            column(ReportForNavId_8129; 8129)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if ShowDialog then
                  Window.Update;

                if (CalculatePer = Calculateper::Item) and ("Costing Method" = "costing method"::Average) then begin
                  CalendarPeriod."Period Start" := PostingDate;
                  AvgCostAdjmtPoint."Valuation Date" := PostingDate;
                  AvgCostAdjmtPoint.GetValuationPeriod(CalendarPeriod);
                  if PostingDate <> CalendarPeriod."Period End" then
                    Error(Text011,"No.",PostingDate,CalendarPeriod."Period End");
                end;

                ValJnlBuffer.Reset;
                ValJnlBuffer.DeleteAll;
                IncludeExpectedCost := ("Costing Method" = "costing method"::Standard) and (CalculatePer = Calculateper::Item);
                ItemLedgEntry.SetRange("Item No.","No.");
                ItemLedgEntry.SetRange(Positive,true);
                Copyfilter("Location Filter",ItemLedgEntry."Location Code");
                Copyfilter("Variant Filter",ItemLedgEntry."Variant Code");
                if ItemLedgEntry.Find('-') then
                  repeat
                    if IncludeEntryInCalc(ItemLedgEntry,PostingDate,IncludeExpectedCost) then begin
                      RemQty := ItemLedgEntry.CalculateRemQuantity(ItemLedgEntry."Entry No.",PostingDate);
                      case CalculatePer of
                        Calculateper::"Item Ledger Entry":
                          InsertItemJnlLine(
                            ItemLedgEntry."Entry Type",ItemLedgEntry."Item No.",
                            ItemLedgEntry."Variant Code",ItemLedgEntry."Location Code",RemQty,
                            ItemLedgEntry.CalculateRemInventoryValue(ItemLedgEntry."Entry No.",ItemLedgEntry.Quantity,RemQty,false,PostingDate),
                            ItemLedgEntry."Entry No.",0);
                        Calculateper::Item:
                          InsertValJnlBuffer(
                            ItemLedgEntry."Item No.",ItemLedgEntry."Variant Code",
                            ItemLedgEntry."Location Code",RemQty,
                            ItemLedgEntry.CalculateRemInventoryValue(ItemLedgEntry."Entry No.",ItemLedgEntry.Quantity,RemQty,
                              IncludeExpectedCost and not ItemLedgEntry."Completely Invoiced",PostingDate));
                      end;
                    end;
                  until ItemLedgEntry.Next = 0;

                if CalculatePer = Calculateper::Item then
                  if (GetFilter("Location Filter") <> '') or ByLocation then begin
                    ByLocation2 := true;
                    Copyfilter("Location Filter",Location.Code);
                    if Location.Find('-') then begin
                      Clear(ValJnlBuffer);
                      ValJnlBuffer.SetCurrentkey("Item No.","Location Code","Variant Code");
                      ValJnlBuffer.SetRange("Item No.","No.");
                      repeat
                        ValJnlBuffer.SetRange("Location Code",Location.Code);
                        if (GetFilter("Variant Filter") <> '') or ByVariant then begin
                          ByVariant2 := true;
                          ItemVariant.SetRange("Item No.","No.");
                          Copyfilter("Variant Filter",ItemVariant.Code);
                          if ItemVariant.Find('-') then
                            repeat
                              ValJnlBuffer.SetRange("Variant Code",ItemVariant.Code);
                              Calculate(Item,ItemVariant.Code,Location.Code);
                            until ItemVariant.Next = 0;
                          ValJnlBuffer.SetRange("Variant Code",'');
                          Calculate(Item,'',Location.Code);
                        end else
                          Calculate(Item,'',Location.Code);
                      until Location.Next = 0;
                    end;
                    ValJnlBuffer.SetRange("Location Code",'');
                    if ByVariant then begin
                      ItemVariant.SetRange("Item No.","No.");
                      Copyfilter("Variant Filter",ItemVariant.Code);
                      if ItemVariant.Find('-') then
                        repeat
                          ValJnlBuffer.SetRange("Variant Code",ItemVariant.Code);
                          Calculate(Item,ItemVariant.Code,'');
                        until ItemVariant.Next = 0;
                      ValJnlBuffer.SetRange("Variant Code",'');
                      Calculate(Item,'','');
                    end else
                      Calculate(Item,'','');
                  end else
                    if (GetFilter("Variant Filter") <> '') or ByVariant then begin
                      ByVariant2 := true;
                      ItemVariant.SetRange("Item No.","No.");
                      Copyfilter("Variant Filter",ItemVariant.Code);
                      if ItemVariant.Find('-') then begin
                        ValJnlBuffer.Reset;
                        ValJnlBuffer.SetCurrentkey("Item No.","Variant Code");
                        ValJnlBuffer.SetRange("Item No.","No.");
                        repeat
                          ValJnlBuffer.SetRange("Variant Code",ItemVariant.Code);
                          Calculate(Item,ItemVariant.Code,'');
                        until ItemVariant.Next = 0;
                      end;
                      ValJnlBuffer.SetRange("Location Code");
                      ValJnlBuffer.SetRange("Variant Code",'');
                      Calculate(Item,'','');
                    end else begin
                      ValJnlBuffer.Reset;
                      ValJnlBuffer.SetCurrentkey("Item No.");
                      ValJnlBuffer.SetRange("Item No.","No.");
                      Calculate(Item,'','');
                    end;
            end;

            trigger OnPostDataItem()
            var
                SKU: Record "Stockkeeping Unit";
                ItemCostMgt: Codeunit ItemCostManagement;
            begin
                if not UpdStdCost then
                  exit;

                if ByLocation then
                  Copyfilter("Location Filter",SKU."Location Code");
                if ByVariant then
                  Copyfilter("Variant Filter",SKU."Variant Code");

                NewStdCostItem.CopyFilters(Item);
                if NewStdCostItem.Find('-') then
                  repeat
                    if not UpdatedStdCostSKU.Get('',NewStdCostItem."No.",'') then
                      ItemCostMgt.UpdateStdCostShares(NewStdCostItem);

                    SKU.SetRange("Item No.",NewStdCostItem."No.");
                    if SKU.Find('-') then
                      repeat
                        if not UpdatedStdCostSKU.Get(SKU."Location Code",NewStdCostItem."No.",SKU."Variant Code") then begin
                          SKU.Validate("Standard Cost",NewStdCostItem."Standard Cost");
                          SKU.Modify;
                        end;
                      until SKU.Next = 0;
                  until NewStdCostItem.Next = 0;
            end;

            trigger OnPreDataItem()
            var
                TempErrorBuf: Record "Error Buffer" temporary;
            begin
                ItemJnlTemplate.Get(ItemJnlLine."Journal Template Name");
                ItemJnlTemplate.TestField(Type,ItemJnlTemplate.Type::Revaluation);

                ItemJnlBatch.Get(ItemJnlLine."Journal Template Name",ItemJnlLine."Journal Batch Name");
                if NextDocNo = '' then begin
                  if ItemJnlBatch."No. Series" <> '' then begin
                    ItemJnlLine.SetRange("Journal Template Name",ItemJnlLine."Journal Template Name");
                    ItemJnlLine.SetRange("Journal Batch Name",ItemJnlLine."Journal Batch Name");
                    if not ItemJnlLine.FindFirst then
                      NextDocNo := NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series",PostingDate,false);
                    ItemJnlLine.Init;
                  end;
                  if NextDocNo = '' then
                    Error(Text003);
                end;

                CalcInvtValCheck.SetProperties(PostingDate,CalculatePer,ByLocation,ByVariant,ShowDialog,false);
                CalcInvtValCheck.RunCheck(Item,TempErrorBuf);

                ItemLedgEntry.SetCurrentkey("Item No.",Positive,"Location Code","Variant Code");

                NextLineNo := 0;

                if ShowDialog then
                  Window.Open(Text010,"No.");

                GLSetup.Get;
                SourceCodeSetup.Get;

                if CalcBase in [Calcbase::"Standard Cost - Assembly List",Calcbase::"Standard Cost - Manufacturing"] then begin
                  CalculateStdCost.SetProperties(PostingDate,true,CalcBase = Calcbase::"Standard Cost - Assembly List",false,'',true);
                  CalculateStdCost.CalcItems(Item,NewStdCostItem);
                  Clear(CalculateStdCost);
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate;PostingDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.';
                    }
                    field(NextDocNo;NextDocNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the number of the document that is processed by the report or batch job.';
                    }
                    field(CalculatePer;CalculatePer)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Calculate Per';
                        OptionCaption = 'Item Ledger Entry,Item';
                        ToolTip = 'Specifies if you want to sum up the inventory value per item ledger entry or per item.';

                        trigger OnValidate()
                        begin
                            if CalculatePer = Calculateper::Item then
                              ItemCalculatePerOnValidate;
                            if CalculatePer = Calculateper::"Item Ledger Entry" then
                              ItemLedgerEntryCalculatePerOnV;
                        end;
                    }
                    field("By Location";ByLocation)
                    {
                        ApplicationArea = Basic;
                        Caption = 'By Location';
                        Enabled = ByLocationEnable;
                        ToolTip = 'Specifies whether to calculate inventory by location.';
                    }
                    field("By Variant";ByVariant)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'By Variant';
                        Enabled = ByVariantEnable;
                        ToolTip = 'Specifies the item variants that you want the batch job to consider.';
                    }
                    field(UpdStdCost;UpdStdCost)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Update Standard Cost';
                        Enabled = UpdStdCostEnable;
                        ToolTip = 'Specifies if you want the items'' standard cost to be updated according to the calculated inventory value.';
                    }
                    field(CalcBase;CalcBase)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Calculation Base';
                        Enabled = CalcBaseEnable;
                        OptionCaption = ' ,Last Direct Unit Cost,Standard Cost - Assembly List,Standard Cost - Manufacturing';
                        ToolTip = 'Specifies if the revaluation journal will suggest a new value for the Unit Cost (Revalued) field.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            UpdStdCostEnable := true;
            CalcBaseEnable := true;
            ByVariantEnable := true;
            ByLocationEnable := true;
        end;

        trigger OnOpenPage()
        begin
            if PostingDate = 0D then
              PostingDate := WorkDate;
            ValidatePostingDate;

            ValidateCalcLevel;
        end;
    }

    labels
    {
    }

    var
        Text003: label 'You must enter a document number.';
        Text010: label 'Processing items #1##########';
        NewStdCostItem: Record Item temporary;
        UpdatedStdCostSKU: Record "Stockkeeping Unit" temporary;
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlLine: Record "Item Journal Line";
        ValJnlBuffer: Record "Item Journal Buffer" temporary;
        ItemJnlTemplate: Record "Item Journal Template";
        ItemLedgEntry: Record "Item Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        SourceCodeSetup: Record "Source Code Setup";
        Location: Record Location;
        ItemVariant: Record "Item Variant";
        AvgCostAdjmtPoint: Record "Avg. Cost Adjmt. Entry Point";
        CalendarPeriod: Record Date;
        CalcInvtValCheck: Codeunit "Calc. Inventory Value-Check";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        Window: Dialog;
        CalculatePer: Option "Item Ledger Entry",Item;
        CalcBase: Option " ","Last Direct Unit Cost","Standard Cost - Assembly List","Standard Cost - Manufacturing";
        PostingDate: Date;
        NextDocNo: Code[20];
        AverageUnitCostLCY: Decimal;
        RemQty: Decimal;
        NextLineNo: Integer;
        NextLineNo2: Integer;
        ByLocation: Boolean;
        ByVariant: Boolean;
        ByLocation2: Boolean;
        ByVariant2: Boolean;
        UpdStdCost: Boolean;
        ShowDialog: Boolean;
        IncludeExpectedCost: Boolean;
        Text011: label 'You cannot revalue by Calculate Per Item for item %1 using posting date %2. You can only use the posting date %3 for this period.';
        [InDataSet]
        ByLocationEnable: Boolean;
        [InDataSet]
        ByVariantEnable: Boolean;
        [InDataSet]
        CalcBaseEnable: Boolean;
        [InDataSet]
        UpdStdCostEnable: Boolean;
        DuplWarningQst: label 'Duplicate Revaluation Journals will be generated.\Do you want to continue?';
        HideDuplWarning: Boolean;

    local procedure IncludeEntryInCalc(ItemLedgEntry: Record "Item Ledger Entry";PostingDate: Date;IncludeExpectedCost: Boolean): Boolean
    begin
        with ItemLedgEntry do begin
          if IncludeExpectedCost then
            exit("Posting Date" in [0D..PostingDate]);
          exit("Completely Invoiced" and ("Last Invoice Date" in [0D..PostingDate]));
        end;
    end;


    procedure SetItemJnlLine(var NewItemJnlLine: Record "Item Journal Line")
    begin
        ItemJnlLine := NewItemJnlLine;
    end;

    local procedure ValidatePostingDate()
    begin
        ItemJnlBatch.Get(ItemJnlLine."Journal Template Name",ItemJnlLine."Journal Batch Name");
        if ItemJnlBatch."No. Series" = '' then
          NextDocNo := ''
        else begin
          NextDocNo := NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series",PostingDate,false);
          Clear(NoSeriesMgt);
        end;
    end;

    local procedure ValidateCalcLevel()
    begin
        PageValidateCalcLevel;
        exit;
    end;

    local procedure InsertValJnlBuffer(ItemNo2: Code[20];VariantCode2: Code[10];LocationCode2: Code[10];Quantity2: Decimal;Amount2: Decimal)
    begin
        ValJnlBuffer.Reset;
        ValJnlBuffer.SetCurrentkey("Item No.","Location Code","Variant Code");
        ValJnlBuffer.SetRange("Item No.",ItemNo2);
        ValJnlBuffer.SetRange("Location Code",LocationCode2);
        ValJnlBuffer.SetRange("Variant Code",VariantCode2);
        if ValJnlBuffer.FindFirst then begin
          ValJnlBuffer.Quantity := ValJnlBuffer.Quantity + Quantity2;
          ValJnlBuffer."Inventory Value (Calculated)" :=
            ValJnlBuffer."Inventory Value (Calculated)" + Amount2;
          ValJnlBuffer.Modify;
        end else
          if Quantity2 <> 0 then begin
            NextLineNo2 := NextLineNo2 + 10000;
            ValJnlBuffer.Init;
            ValJnlBuffer."Line No." := NextLineNo2;
            ValJnlBuffer."Item No." := ItemNo2;
            ValJnlBuffer."Variant Code" := VariantCode2;
            ValJnlBuffer."Location Code" := LocationCode2;
            ValJnlBuffer.Quantity := Quantity2;
            ValJnlBuffer."Inventory Value (Calculated)" := Amount2;
            ValJnlBuffer.Insert;
          end;
    end;

    local procedure CalcAverageUnitCost(BufferQty: Decimal;var InvtValueCalc: Decimal;var AppliedAmount: Decimal)
    var
        ValueEntry: Record "Value Entry";
        AverageQty: Decimal;
        AverageCost: Decimal;
        NotComplInvQty: Decimal;
        NotComplInvValue: Decimal;
    begin
        with ValueEntry do begin
          "Item No." := Item."No.";
          "Valuation Date" := PostingDate;
          if ValJnlBuffer.GetFilter("Location Code") <> '' then
            "Location Code" := ValJnlBuffer.GetFilter("Location Code");
          if ValJnlBuffer.GetFilter("Variant Code") <> '' then
            "Variant Code" := ValJnlBuffer.GetFilter("Variant Code");
          SumCostsTillValuationDate(ValueEntry);
          AverageQty := "Item Ledger Entry Quantity";
          AverageCost := "Cost Amount (Actual)" + "Cost Amount (Expected)";

          CalcNotComplInvcdTransfer(NotComplInvQty,NotComplInvValue);
          AverageQty := AverageQty - NotComplInvQty;
          if (AverageQty > 0) and (NotComplInvValue < 0) then
            AverageCost := AverageCost + (InvtValueCalc / BufferQty * AverageQty + NotComplInvValue);

          Reset;
          SetRange("Item No.",Item."No.");
          SetRange("Valuation Date",0D,PostingDate);
          SetFilter("Location Code",ValJnlBuffer.GetFilter("Location Code"));
          SetFilter("Variant Code",ValJnlBuffer.GetFilter("Variant Code"));
          SetRange(Inventoriable,true);
          SetRange("Item Charge No.",'');
          SetFilter("Posting Date",'>%1',PostingDate);
          SetFilter("Entry Type",'<>%1',"entry type"::Revaluation);
          if FindSet then
            repeat
              AverageQty := AverageQty - "Item Ledger Entry Quantity";
              AverageCost := AverageCost - "Cost Amount (Actual)" - "Cost Amount (Expected)";
            until Next = 0;
        end;

        if AverageQty <> 0 then begin
          AverageUnitCostLCY := AverageCost / AverageQty;
          if AverageUnitCostLCY < 0 then
            AverageUnitCostLCY := 0;
        end else
          AverageUnitCostLCY := 0;

        AppliedAmount := InvtValueCalc;
        InvtValueCalc := BufferQty * AverageUnitCostLCY;
    end;

    local procedure CalcNotComplInvcdTransfer(var NotComplInvQty: Decimal;var NotComplInvValue: Decimal)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        RemQty: Decimal;
        RemInvValue: Decimal;
        i: Integer;
    begin
        for i := 1 to 2 do
          with ItemLedgEntry do begin
            SetCurrentkey("Item No.",Positive,"Location Code","Variant Code");
            SetRange("Item No.",Item."No.");
            SetRange(Positive,i = 1);
            Item.Copyfilter("Location Filter","Location Code");
            Item.Copyfilter("Variant Filter","Variant Code");
            if Find('-') then
              repeat
                if (Quantity = "Invoiced Quantity") and
                   not "Completely Invoiced" and
                   ("Last Invoice Date" in [0D..PostingDate]) and
                   ("Invoiced Quantity" <> 0)
                then begin
                  RemQty := Quantity;
                  RemInvValue := CalculateRemInventoryValue("Entry No.",Quantity,RemQty,false,PostingDate);
                  NotComplInvQty := NotComplInvQty + RemQty;
                  NotComplInvValue := NotComplInvValue + RemInvValue;
                end;
              until Next = 0;
          end;
    end;

    local procedure InsertItemJnlLine(EntryType2: Option;ItemNo2: Code[20];VariantCode2: Code[10];LocationCode2: Code[10];Quantity2: Decimal;Amount2: Decimal;ApplyToEntry2: Integer;AppliedAmount: Decimal)
    var
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
    begin
        if Quantity2 = 0 then
          exit;

        with ItemJnlLine do begin
          if not HideDuplWarning then
            if ItemJnlLineExists(ItemJnlLine,ItemNo2,VariantCode2,LocationCode2,ApplyToEntry2) then
              if Confirm(DuplWarningQst) then
                HideDuplWarning := true
              else
                Error('');
          if NextLineNo = 0 then begin
            LockTable;
            SetRange("Journal Template Name","Journal Template Name");
            SetRange("Journal Batch Name","Journal Batch Name");
            if FindLast then
              NextLineNo := "Line No.";
          end;

          NextLineNo := NextLineNo + 10000;
          Init;
          "Line No." := NextLineNo;
          "Value Entry Type" := "value entry type"::Revaluation;
          Validate("Posting Date",PostingDate);
          Validate("Entry Type",EntryType2);
          Validate("Document No.",NextDocNo);
          Validate("Item No.",ItemNo2);
          "Reason Code" := ItemJnlBatch."Reason Code";
          "Variant Code" := VariantCode2;
          "Location Code" := LocationCode2;
          "Source Code" := SourceCodeSetup."Revaluation Journal";
          Validate("Unit Amount",0);
          if ApplyToEntry2 <> 0 then
            "Inventory Value Per" := "inventory value per"::" "
          else
            if ByLocation2 and ByVariant2 then
              "Inventory Value Per" := "inventory value per"::"Location and Variant"
            else
              if ByLocation2 then
                "Inventory Value Per" := "inventory value per"::Location
              else
                if ByVariant2 then
                  "Inventory Value Per" := "inventory value per"::Variant
                else
                  "Inventory Value Per" := "inventory value per"::Item;
          if CalculatePer = Calculateper::"Item Ledger Entry" then begin
            "Applies-to Entry" := ApplyToEntry2;
            CopyDim(ItemLedgEntry."Dimension Set ID");
          end;
          Validate(Quantity,Quantity2);
          Validate("Inventory Value (Calculated)",ROUND(Amount2,GLSetup."Amount Rounding Precision"));
          case CalcBase of
            Calcbase::" ":
              Validate("Inventory Value (Revalued)","Inventory Value (Calculated)");
            Calcbase::"Last Direct Unit Cost":
              if SKU.Get("Location Code","Item No.","Variant Code") then
                Validate("Unit Cost (Revalued)",SKU."Last Direct Cost")
              else begin
                Item.Get("Item No.");
                Validate("Unit Cost (Revalued)",Item."Last Direct Cost");
              end;
            Calcbase::"Standard Cost - Assembly List",
            Calcbase::"Standard Cost - Manufacturing":
              begin
                if NewStdCostItem.Get(ItemNo2) then begin
                  Validate("Unit Cost (Revalued)",NewStdCostItem."Standard Cost");
                  "Single-Level Material Cost" := NewStdCostItem."Single-Level Material Cost";
                  "Single-Level Capacity Cost" := NewStdCostItem."Single-Level Capacity Cost";
                  "Single-Level Subcontrd. Cost" := NewStdCostItem."Single-Level Subcontrd. Cost";
                  "Single-Level Cap. Ovhd Cost" := NewStdCostItem."Single-Level Cap. Ovhd Cost";
                  "Single-Level Mfg. Ovhd Cost" := NewStdCostItem."Single-Level Mfg. Ovhd Cost";
                  "Rolled-up Material Cost" := NewStdCostItem."Rolled-up Material Cost";
                  "Rolled-up Capacity Cost" := NewStdCostItem."Rolled-up Capacity Cost";
                  "Rolled-up Subcontracted Cost" := NewStdCostItem."Rolled-up Subcontracted Cost";
                  "Rolled-up Mfg. Ovhd Cost" := NewStdCostItem."Rolled-up Mfg. Ovhd Cost";
                  "Rolled-up Cap. Overhead Cost" := NewStdCostItem."Rolled-up Cap. Overhead Cost";
                  UpdatedStdCostSKU."Item No." := ItemNo2;
                  UpdatedStdCostSKU."Location Code" := LocationCode2;
                  UpdatedStdCostSKU."Variant Code" := VariantCode2;
                  UpdatedStdCostSKU.Insert;
                end else
                  Validate("Inventory Value (Revalued)","Inventory Value (Calculated)");
              end;
          end;
          "Update Standard Cost" := UpdStdCost;
          "Partial Revaluation" := true;
          "Applied Amount" := AppliedAmount;
          Insert;
        end;
    end;


    procedure InitializeRequest(NewPostingDate: Date;NewDocNo: Code[20];NewHideDuplWarning: Boolean;NewCalculatePer: Option;NewByLocation: Boolean;NewByVariant: Boolean;NewUpdStdCost: Boolean;NewCalcBase: Option;NewShowDialog: Boolean)
    begin
        PostingDate := NewPostingDate;
        NextDocNo := NewDocNo;
        CalculatePer := NewCalculatePer;
        ByLocation := NewByLocation;
        ByVariant := NewByVariant;
        UpdStdCost := NewUpdStdCost;
        CalcBase := NewCalcBase;
        ShowDialog := NewShowDialog;
        HideDuplWarning := NewHideDuplWarning;
    end;

    local procedure PageValidateCalcLevel()
    begin
        if CalculatePer = Calculateper::"Item Ledger Entry" then begin
          ByLocation := false;
          ByVariant := false;
          CalcBase := Calcbase::" ";
          UpdStdCost := false;
        end;
    end;

    local procedure ItemLedgerEntryCalculatePerOnV()
    begin
        ValidateCalcLevel;
    end;

    local procedure ItemCalculatePerOnValidate()
    begin
        ValidateCalcLevel;
    end;

    local procedure ItemJnlLineExists(ItemJnlLine: Record "Item Journal Line";ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];ApplyToEntry: Integer): Boolean
    begin
        with ItemJnlLine do begin
          SetRange("Journal Template Name","Journal Template Name");
          SetRange("Journal Batch Name","Journal Batch Name");
          SetRange("Item No.",ItemNo);
          SetRange("Variant Code",VariantCode);
          SetRange("Location Code",LocationCode);
          SetRange("Applies-to Entry",ApplyToEntry);
          exit(not IsEmpty);
        end;
    end;

    local procedure Calculate(Item: Record Item;VariantCode: Code[10];LocationCode: Code[10])
    var
        AppliedAmount: Decimal;
    begin
        ValJnlBuffer.CalcSums(Quantity,"Inventory Value (Calculated)");
        if ValJnlBuffer.Quantity <> 0 then begin
          AppliedAmount := 0;
          if Item."Costing Method" = Item."costing method"::Average then
            CalcAverageUnitCost(
              ValJnlBuffer.Quantity,ValJnlBuffer."Inventory Value (Calculated)",AppliedAmount);
          InsertItemJnlLine(ItemJnlLine."entry type"::"Positive Adjmt.",
            Item."No.",VariantCode,LocationCode,ValJnlBuffer.Quantity,ValJnlBuffer."Inventory Value (Calculated)",
            0,AppliedAmount);
        end;
    end;
}

