#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5407 "Prod. Order Status Management"
{
    Permissions = TableData "Source Code Setup"=r,
                  TableData "Production Order"=rimd,
                  TableData "Prod. Order Capacity Need"=rid,
                  TableData "Inventory Adjmt. Entry (Order)"=rim;
    TableNo = "Production Order";

    trigger OnRun()
    var
        ChangeStatusForm: Page "Change Status on Prod. Order";
    begin
        ChangeStatusForm.Set(Rec);
        if ChangeStatusForm.RunModal = Action::Yes then begin
          ChangeStatusForm.ReturnPostingInfo(NewStatus,NewPostingDate,NewUpdateUnitCost);
          ChangeStatusOnProdOrder(Rec,NewStatus,NewPostingDate,NewUpdateUnitCost);
          Commit;
          Message(Text000,Status,TableCaption,"No.",ToProdOrder.Status,ToProdOrder.TableCaption,ToProdOrder."No.")
        end;
    end;

    var
        Text000: label '%2 %3  with status %1 has been changed to %5 %6 with status %4.';
        Text002: label 'Posting Automatic consumption...\\';
        Text003: label 'Posting lines         #1###### @2@@@@@@@@@@@@@';
        Text004: label '%1 %2 has not been finished. Some output is still missing. Do you still want to finish the order?';
        Text005: label 'The update has been interrupted to respect the warning.';
        Text006: label '%1 %2 has not been finished. Some consumption is still missing. Do you still want to finish the order?';
        ToProdOrder: Record "Production Order";
        SourceCodeSetup: Record "Source Code Setup";
        Item: Record Item;
        InvtSetup: Record "Inventory Setup";
        DimMgt: Codeunit DimensionManagement;
        ReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        ReserveProdOrderComp: Codeunit "Prod. Order Comp.-Reserve";
        ReservMgt: Codeunit "Reservation Management";
        CalendarMgt: Codeunit "Shop Calendar Management";
        UpdateProdOrderCost: Codeunit "Update Prod. Order Cost";
        ACYMgt: Codeunit "Additional-Currency Management";
        WhseProdRelease: Codeunit "Whse.-Production Release";
        WhseOutputProdRelease: Codeunit "Whse.-Output Prod. Release";
        InvtAdjmt: Codeunit "Inventory Adjustment";
        NewStatus: Option Quote,Planned,"Firm Planned",Released,Finished;
        NewPostingDate: Date;
        NewUpdateUnitCost: Boolean;
        SourceCodeSetupRead: Boolean;
        Text008: label '%1 %2 cannot be finished as the associated subcontract order %3 has not been fully delivered.';
        Text009: label 'You cannot finish line %1 on %2 %3. It has consumption or capacity posted with no output.';
        Text010: label 'You must specify a %1 in %2 %3 %4.';


    procedure ChangeStatusOnProdOrder(ProdOrder: Record "Production Order";NewStatus: Option Quote,Planned,"Firm Planned",Released,Finished;NewPostingDate: Date;NewUpdateUnitCost: Boolean)
    begin
        SetPostingInfo(NewStatus,NewPostingDate,NewUpdateUnitCost);
        if NewStatus = Newstatus::Finished then begin
          CheckBeforeFinishProdOrder(ProdOrder);
          FlushProdOrder(ProdOrder,NewStatus,NewPostingDate);
          ReservMgt.DeleteDocumentReservation(Database::"Prod. Order Line",ProdOrder.Status,ProdOrder."No.",false);
          ErrorIfUnableToClearWIP(ProdOrder);
          TransProdOrder(ProdOrder);

          InvtSetup.Get;
          if InvtSetup."Automatic Cost Adjustment" <>
             InvtSetup."automatic cost adjustment"::Never
          then begin
            InvtAdjmt.SetProperties(true,InvtSetup."Automatic Cost Posting");
            InvtAdjmt.MakeMultiLevelAdjmt;
          end;

          WhseProdRelease.FinishedDelete(ProdOrder);
          WhseOutputProdRelease.FinishedDelete(ProdOrder);
        end else begin
          TransProdOrder(ProdOrder);
          FlushProdOrder(ProdOrder,NewStatus,NewPostingDate);
          WhseProdRelease.Release(ProdOrder);
        end;
        Commit;

        Clear(InvtAdjmt);
    end;

    local procedure TransProdOrder(var FromProdOrder: Record "Production Order")
    var
        ToProdOrderLine: Record "Prod. Order Line";
    begin
        with FromProdOrder do begin
          ToProdOrderLine.LockTable;

          ToProdOrder := FromProdOrder;
          ToProdOrder.Status := NewStatus;

          case Status of
            Status::Simulated:
              ToProdOrder."Simulated Order No." := "No.";
            Status::Planned:
              ToProdOrder."Planned Order No." := "No.";
            Status::"Firm Planned":
              ToProdOrder."Firm Planned Order No." := "No.";
            Status::Released:
              ToProdOrder."Finished Date" := NewPostingDate;
          end;

          ToProdOrder.TestNoSeries;
          if (ToProdOrder.GetNoSeriesCode <> GetNoSeriesCode) and
             (ToProdOrder.Status <> ToProdOrder.Status::Finished)
          then begin
            ToProdOrder."No." := '';
            ToProdOrder."Due Date" := 0D;
          end;

          ToProdOrder.Insert(true);
          ToProdOrder."Starting Time" := "Starting Time";
          ToProdOrder."Starting Date" := "Starting Date";
          ToProdOrder."Ending Time" := "Ending Time";
          ToProdOrder."Ending Date" := "Ending Date";
          ToProdOrder."Due Date" := "Due Date";
          ToProdOrder."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
          ToProdOrder."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
          ToProdOrder."Dimension Set ID" := "Dimension Set ID";
          ToProdOrder.Modify;

          TransProdOrderLine(FromProdOrder);
          TransProdOrderRtngLine(FromProdOrder);
          TransProdOrderComp(FromProdOrder);
          TransProdOrderRtngTool(FromProdOrder);
          TransProdOrderRtngPersnl(FromProdOrder);
          TransProdOrdRtngQltyMeas(FromProdOrder);
          TransProdOrderCmtLine(FromProdOrder);
          TransProdOrderRtngCmtLn(FromProdOrder);
          TransProdOrderBOMCmtLine(FromProdOrder);
          TransProdOrderCapNeed(FromProdOrder);
          Delete;
          FromProdOrder := ToProdOrder;
        end;
    end;

    local procedure TransProdOrderLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderLine: Record "Prod. Order Line";
        ToProdOrderLine: Record "Prod. Order Line";
        InvtAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)";
    begin
        with FromProdOrderLine do begin
          SetRange(Status,FromProdOrder.Status);
          SetRange("Prod. Order No.",FromProdOrder."No.");
          LockTable;
          if FindSet then begin
            repeat
              ToProdOrderLine := FromProdOrderLine;
              ToProdOrderLine.Status := ToProdOrder.Status;
              ToProdOrderLine."Prod. Order No." := ToProdOrder."No.";
              ToProdOrderLine.Insert;
              if NewStatus = Newstatus::Finished then begin
                if InvtAdjmtEntryOrder.Get(InvtAdjmtEntryOrder."order type"::Production,"Prod. Order No.","Line No.") then begin
                  InvtAdjmtEntryOrder."Routing No." := ToProdOrderLine."Routing No.";
                  InvtAdjmtEntryOrder.Modify;
                end else
                  InvtAdjmtEntryOrder.SetProdOrderLine(FromProdOrderLine);
                InvtAdjmtEntryOrder."Cost is Adjusted" := false;
                InvtAdjmtEntryOrder."Is Finished" := true;
                InvtAdjmtEntryOrder.Modify;

                if NewUpdateUnitCost then
                  UpdateProdOrderCost.UpdateUnitCostOnProdOrder(FromProdOrderLine,true,true);
                ToProdOrderLine."Unit Cost (ACY)" :=
                  ACYMgt.CalcACYAmt(ToProdOrderLine."Unit Cost",NewPostingDate,true);
                ToProdOrderLine."Cost Amount (ACY)" :=
                  ACYMgt.CalcACYAmt(ToProdOrderLine."Cost Amount",NewPostingDate,false);
                ReservMgt.SetProdOrderLine(FromProdOrderLine);
                ReservMgt.DeleteReservEntries(true,0);
              end else begin
                if Item.Get("Item No.") then begin
                  if (Item."Costing Method" <> Item."costing method"::Standard) and NewUpdateUnitCost then
                    UpdateProdOrderCost.UpdateUnitCostOnProdOrder(FromProdOrderLine,false,true);
                end;
                ToProdOrderLine.BlockDynamicTracking(true);
                ToProdOrderLine.Validate(Quantity);
                ReserveProdOrderLine.TransferPOLineToPOLine(FromProdOrderLine,ToProdOrderLine,0,true);
              end;
              ToProdOrderLine.Validate("Unit Cost","Unit Cost");
              ToProdOrderLine.Modify;
            until Next = 0;
            DeleteAll;
          end;
        end;
    end;

    local procedure TransProdOrderRtngLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngLine: Record "Prod. Order Routing Line";
        ToProdOrderRtngLine: Record "Prod. Order Routing Line";
        ProdOrderCapNeed: Record "Prod. Order Capacity Need";
    begin
        with FromProdOrderRtngLine do begin
          SetRange(Status,FromProdOrder.Status);
          SetRange("Prod. Order No.",FromProdOrder."No.");
          LockTable;
          if FindSet then begin
            repeat
              ToProdOrderRtngLine := FromProdOrderRtngLine;
              ToProdOrderRtngLine.Status := ToProdOrder.Status;
              ToProdOrderRtngLine."Prod. Order No." := ToProdOrder."No.";
              if ToProdOrder.Status = ToProdOrder.Status::Released then
                ToProdOrderRtngLine."Routing Status" := "routing status"::Planned;

              if ToProdOrder.Status in [ToProdOrder.Status::"Firm Planned",ToProdOrder.Status::Released] then begin
                ProdOrderCapNeed.SetRange("Prod. Order No.",FromProdOrder."No.");
                ProdOrderCapNeed.SetRange(Status,FromProdOrder.Status);
                ProdOrderCapNeed.SetRange("Routing Reference No.","Routing Reference No.");
                ProdOrderCapNeed.SetRange("Operation No.","Operation No.");
                ProdOrderCapNeed.SetRange("Requested Only",false);
                ProdOrderCapNeed.CalcSums("Needed Time (ms)");
                ToProdOrderRtngLine."Expected Capacity Need" := ProdOrderCapNeed."Needed Time (ms)";
              end;
              ToProdOrderRtngLine.Insert;
            until Next = 0;
            DeleteAll;
          end;
        end;
    end;

    local procedure TransProdOrderComp(FromProdOrder: Record "Production Order")
    var
        FromProdOrderComp: Record "Prod. Order Component";
        ToProdOrderComp: Record "Prod. Order Component";
        Location: Record Location;
    begin
        with FromProdOrderComp do begin
          SetRange(Status,FromProdOrder.Status);
          SetRange("Prod. Order No.",FromProdOrder."No.");
          LockTable;
          if FindSet then begin
            repeat
              if Location.Get("Location Code") and
                 Location."Bin Mandatory" and
                 not Location."Directed Put-away and Pick" and
                 (Status = Status::"Firm Planned") and
                 (ToProdOrder.Status = ToProdOrder.Status::Released) and
                 ("Flushing Method" in ["flushing method"::Forward,"flushing method"::"Pick + Forward"]) and
                 ("Routing Link Code" = '') and
                 ("Bin Code" = '')
              then
                Error(
                  Text010,
                  FieldCaption("Bin Code"),
                  TableCaption,
                  FieldCaption("Line No."),
                  "Line No.");
              ToProdOrderComp := FromProdOrderComp;
              ToProdOrderComp.Status := ToProdOrder.Status;
              ToProdOrderComp."Prod. Order No." := ToProdOrder."No.";
              ToProdOrderComp.Insert;
              if NewStatus = Newstatus::Finished then begin
                ReservMgt.SetProdOrderComponent(FromProdOrderComp);
                ReservMgt.DeleteReservEntries(true,0);
              end else begin
                ToProdOrderComp.BlockDynamicTracking(true);
                ToProdOrderComp.Validate("Expected Quantity");
                ReserveProdOrderComp.TransferPOCompToPOComp(FromProdOrderComp,ToProdOrderComp,0,true);
                if ToProdOrderComp.Status in [ToProdOrderComp.Status::"Firm Planned",ToProdOrderComp.Status::Released] then
                  ToProdOrderComp.AutoReserve;
              end;
              ToProdOrderComp.Modify;
            until Next = 0;
            DeleteAll;
          end;
        end;
    end;

    local procedure TransProdOrderRtngTool(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngTool: Record "Prod. Order Routing Tool";
        ToProdOrderRoutTool: Record "Prod. Order Routing Tool";
    begin
        with FromProdOrderRtngTool do begin
          SetRange(Status,FromProdOrder.Status);
          SetRange("Prod. Order No.",FromProdOrder."No.");
          LockTable;
          if FindSet then begin
            repeat
              ToProdOrderRoutTool := FromProdOrderRtngTool;
              ToProdOrderRoutTool.Status := ToProdOrder.Status;
              ToProdOrderRoutTool."Prod. Order No." := ToProdOrder."No.";
              ToProdOrderRoutTool.Insert;
            until Next = 0;
            DeleteAll;
          end;
        end;
    end;

    local procedure TransProdOrderRtngPersnl(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngPersonnel: Record "Prod. Order Routing Personnel";
        ToProdOrderRtngPersonnel: Record "Prod. Order Routing Personnel";
    begin
        with FromProdOrderRtngPersonnel do begin
          SetRange(Status,FromProdOrder.Status);
          SetRange("Prod. Order No.",FromProdOrder."No.");
          LockTable;
          if FindSet then begin
            repeat
              ToProdOrderRtngPersonnel := FromProdOrderRtngPersonnel;
              ToProdOrderRtngPersonnel.Status := ToProdOrder.Status;
              ToProdOrderRtngPersonnel."Prod. Order No." := ToProdOrder."No.";
              ToProdOrderRtngPersonnel.Insert;
            until Next = 0;
            DeleteAll;
          end;
        end;
    end;

    local procedure TransProdOrdRtngQltyMeas(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngQltyMeas: Record "Prod. Order Rtng Qlty Meas.";
        ToProdOrderRtngQltyMeas: Record "Prod. Order Rtng Qlty Meas.";
    begin
        with FromProdOrderRtngQltyMeas do begin
          SetRange(Status,FromProdOrder.Status);
          SetRange("Prod. Order No.",FromProdOrder."No.");
          LockTable;
          if FindSet then begin
            repeat
              ToProdOrderRtngQltyMeas := FromProdOrderRtngQltyMeas;
              ToProdOrderRtngQltyMeas.Status := ToProdOrder.Status;
              ToProdOrderRtngQltyMeas."Prod. Order No." := ToProdOrder."No.";
              ToProdOrderRtngQltyMeas.Insert;
            until Next = 0;
            DeleteAll;
          end;
        end;
    end;

    local procedure TransProdOrderCmtLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderCommentLine: Record "Prod. Order Comment Line";
        ToProdOrderCommentLine: Record "Prod. Order Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with FromProdOrderCommentLine do begin
          SetRange(Status,FromProdOrder.Status);
          SetRange("Prod. Order No.",FromProdOrder."No.");
          LockTable;
          if FindSet then begin
            repeat
              ToProdOrderCommentLine := FromProdOrderCommentLine;
              ToProdOrderCommentLine.Status := ToProdOrder.Status;
              ToProdOrderCommentLine."Prod. Order No." := ToProdOrder."No.";
              ToProdOrderCommentLine.Insert;
            until Next = 0;
            DeleteAll;
          end;
        end;
        RecordLinkManagement.CopyLinks(FromProdOrder,ToProdOrder);
    end;

    local procedure TransProdOrderRtngCmtLn(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngComment: Record "Prod. Order Rtng Comment Line";
        ToProdOrderRtngComment: Record "Prod. Order Rtng Comment Line";
    begin
        with FromProdOrderRtngComment do begin
          SetRange(Status,FromProdOrder.Status);
          SetRange("Prod. Order No.",FromProdOrder."No.");
          LockTable;
          if FindSet then begin
            repeat
              ToProdOrderRtngComment := FromProdOrderRtngComment;
              ToProdOrderRtngComment.Status := ToProdOrder.Status;
              ToProdOrderRtngComment."Prod. Order No." := ToProdOrder."No.";
              ToProdOrderRtngComment.Insert;
            until Next = 0;
            DeleteAll;
          end;
        end;
    end;

    local procedure TransProdOrderBOMCmtLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderBOMComment: Record "Prod. Order Comp. Cmt Line";
        ToProdOrderBOMComment: Record "Prod. Order Comp. Cmt Line";
    begin
        with FromProdOrderBOMComment do begin
          SetRange(Status,FromProdOrder.Status);
          SetRange("Prod. Order No.",FromProdOrder."No.");
          LockTable;
          if FindSet then begin
            repeat
              ToProdOrderBOMComment := FromProdOrderBOMComment;
              ToProdOrderBOMComment.Status := ToProdOrder.Status;
              ToProdOrderBOMComment."Prod. Order No." := ToProdOrder."No.";
              ToProdOrderBOMComment.Insert;
            until Next = 0;
            DeleteAll;
          end;
        end;
    end;

    local procedure TransProdOrderCapNeed(FromProdOrder: Record "Production Order")
    var
        FromProdOrderCapNeed: Record "Prod. Order Capacity Need";
        ToProdOrderCapNeed: Record "Prod. Order Capacity Need";
    begin
        with FromProdOrderCapNeed do begin
          SetRange(Status,FromProdOrder.Status);
          SetRange("Prod. Order No.",FromProdOrder."No.");
          SetRange("Requested Only",false);
          if NewStatus = Newstatus::Finished then
            DeleteAll
          else begin
            LockTable;
            if FindSet then begin
              repeat
                ToProdOrderCapNeed := FromProdOrderCapNeed;
                ToProdOrderCapNeed.Status := ToProdOrder.Status;
                ToProdOrderCapNeed."Prod. Order No." := ToProdOrder."No.";
                ToProdOrderCapNeed."Allocated Time" := ToProdOrderCapNeed."Needed Time";
                ToProdOrderCapNeed.Insert;
              until Next = 0;
              DeleteAll;
            end;
          end;
        end;
    end;


    procedure FlushProdOrder(ProdOrder: Record "Production Order";NewStatus: Option Simulated,Planned,"Firm Planned",Released,Finished;PostingDate: Date)
    var
        Item: Record Item;
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        ProdOrderComp: Record "Prod. Order Component";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        Window: Dialog;
        QtyToPost: Decimal;
        NoOfRecords: Integer;
        LineCount: Integer;
        OutputQty: Decimal;
        OutputQtyBase: Decimal;
        ActualOutputAndScrapQty: Decimal;
        ActualOutputAndScrapQtyBase: Decimal;
    begin
        if NewStatus < Newstatus::Released then
          exit;

        GetSourceCodeSetup;

        ProdOrderLine.LockTable;
        ProdOrderLine.Reset;
        ProdOrderLine.SetRange(Status,ProdOrder.Status);
        ProdOrderLine.SetRange("Prod. Order No.",ProdOrder."No.");
        if ProdOrderLine.FindSet then
          repeat
            ProdOrderRtngLine.SetCurrentkey("Prod. Order No.",Status,"Flushing Method");
            if NewStatus = Newstatus::Released then
              ProdOrderRtngLine.SetRange("Flushing Method",ProdOrderRtngLine."flushing method"::Forward)
            else begin
              ProdOrderRtngLine.Ascending(false); // In case of backward flushing on the last operation
              ProdOrderRtngLine.SetRange("Flushing Method",ProdOrderRtngLine."flushing method"::Backward);
            end;
            ProdOrderRtngLine.SetRange(Status,ProdOrderLine.Status);
            ProdOrderRtngLine.SetRange("Prod. Order No.",ProdOrder."No.");
            ProdOrderRtngLine.SetRange("Routing No.",ProdOrderLine."Routing No.");
            ProdOrderRtngLine.SetRange("Routing Reference No.",ProdOrderLine."Routing Reference No.");
            ProdOrderRtngLine.LockTable;
            if ProdOrderRtngLine.Find('-') then begin
              // First found operation
              if ProdOrderRtngLine."Flushing Method" = ProdOrderRtngLine."flushing method"::Backward then begin
                ActualOutputAndScrapQtyBase :=
                  CostCalcMgt.CalcActOperOutputAndScrap(ProdOrderLine,ProdOrderRtngLine);
                ActualOutputAndScrapQty := ActualOutputAndScrapQtyBase / ProdOrderLine."Qty. per Unit of Measure";
              end;

              if (ProdOrderRtngLine."Flushing Method" = ProdOrderRtngLine."flushing method"::Forward) or
                 (ProdOrderRtngLine."Next Operation No." = '')
              then begin
                OutputQty := ProdOrderLine."Remaining Quantity";
                OutputQtyBase := ProdOrderLine."Remaining Qty. (Base)";
              end else
                if ProdOrderRtngLine."Next Operation No." <> '' then begin // Not Last Operation
                  OutputQty := ActualOutputAndScrapQty;
                  OutputQtyBase := ActualOutputAndScrapQtyBase;
                end;

              repeat
                ItemJnlLine.Init;
                ItemJnlLine.Validate("Entry Type",ItemJnlLine."entry type"::Output);
                ItemJnlLine.Validate("Posting Date",PostingDate);
                ItemJnlLine."Document No." := ProdOrder."No.";
                ItemJnlLine.Validate("Order Type",ItemJnlLine."order type"::Production);
                ItemJnlLine.Validate("Order No.",ProdOrder."No.");
                ItemJnlLine.Validate("Order Line No.",ProdOrderLine."Line No.");
                ItemJnlLine.Validate("Item No.",ProdOrderLine."Item No.");
                ItemJnlLine.Validate("Routing Reference No.",ProdOrderRtngLine."Routing Reference No.");
                ItemJnlLine.Validate("Routing No.",ProdOrderRtngLine."Routing No.");
                ItemJnlLine.Validate("Variant Code",ProdOrderLine."Variant Code");
                ItemJnlLine."Location Code" := ProdOrderLine."Location Code";
                ItemJnlLine.Validate("Bin Code",ProdOrderLine."Bin Code");
                if ItemJnlLine."Unit of Measure Code" <> ProdOrderLine."Unit of Measure Code" then
                  ItemJnlLine.Validate("Unit of Measure Code",ProdOrderLine."Unit of Measure Code");
                ItemJnlLine.Validate("Operation No.",ProdOrderRtngLine."Operation No.");
                if ProdOrderRtngLine."Concurrent Capacities" = 0 then
                  ProdOrderRtngLine."Concurrent Capacities" := 1;
                SetTimeAndQuantityOmItemJnlLine(ItemJnlLine,ProdOrderRtngLine,OutputQtyBase,OutputQty);
                ItemJnlLine."Source Code" := SourceCodeSetup.Flushing;
                if not (ItemJnlLine.TimeIsEmpty and (ItemJnlLine."Output Quantity" = 0)) then begin
                  DimMgt.UpdateGlobalDimFromDimSetID(ItemJnlLine."Dimension Set ID",ItemJnlLine."Shortcut Dimension 1 Code",
                    ItemJnlLine."Shortcut Dimension 2 Code");
                  if ProdOrderRtngLine."Next Operation No." = '' then
                    ReserveProdOrderLine.TransferPOLineToItemJnlLine(ProdOrderLine,ItemJnlLine,ItemJnlLine."Output Quantity (Base)");
                  ItemJnlPostLine.RunWithCheck(ItemJnlLine);
                end;

                if (ProdOrderRtngLine."Flushing Method" = ProdOrderRtngLine."flushing method"::Backward) and
                   (ProdOrderRtngLine."Next Operation No." = '')
                then begin
                  OutputQty += ActualOutputAndScrapQty;
                  OutputQtyBase += ActualOutputAndScrapQtyBase;
                end;
              until ProdOrderRtngLine.Next = 0;
            end;
          until ProdOrderLine.Next = 0;

        with ProdOrderComp do begin
          SetCurrentkey(Status,"Prod. Order No.","Routing Link Code","Flushing Method");
          if NewStatus = Newstatus::Released then
            SetFilter(
              "Flushing Method",
              '%1|%2',
              "flushing method"::Forward,
              "flushing method"::"Pick + Forward")
          else
            SetFilter(
              "Flushing Method",
              '%1|%2',
              "flushing method"::Backward,
              "flushing method"::"Pick + Backward");
          SetRange("Routing Link Code",'');
          SetRange(Status,Status::Released);
          SetRange("Prod. Order No.",ProdOrder."No.");
          SetFilter("Item No.",'<>%1','');
          LockTable;
          if FindSet then begin
            NoOfRecords := Count;
            Window.Open(
              Text002 +
              Text003);
            LineCount := 0;

            repeat
              LineCount := LineCount + 1;
              Item.Get("Item No.");
              Item.TestField("Rounding Precision");
              Window.Update(1,LineCount);
              Window.Update(2,ROUND(LineCount / NoOfRecords * 10000,1));
              ProdOrderLine.Get(Status,ProdOrder."No.","Prod. Order Line No.");
              if NewStatus = Newstatus::Released then
                QtyToPost := GetNeededQty(1,false)
              else
                QtyToPost := GetNeededQty(0,false);
              QtyToPost := ROUND(QtyToPost,Item."Rounding Precision",'>');

              if QtyToPost <> 0 then begin
                ItemJnlLine.Init;
                ItemJnlLine.Validate("Entry Type",ItemJnlLine."entry type"::Consumption);
                ItemJnlLine.Validate("Posting Date",PostingDate);
                ItemJnlLine."Order Type" := ItemJnlLine."order type"::Production;
                ItemJnlLine."Order No." := ProdOrder."No.";
                ItemJnlLine."Source No." := ProdOrderLine."Item No.";
                ItemJnlLine."Source Type" := ItemJnlLine."source type"::Item;
                ItemJnlLine."Order Line No." := ProdOrderLine."Line No.";
                ItemJnlLine."Document No." := ProdOrder."No.";
                ItemJnlLine.Validate("Item No.","Item No.");
                ItemJnlLine.Validate("Prod. Order Comp. Line No.","Line No.");
                if ItemJnlLine."Unit of Measure Code" <> "Unit of Measure Code" then
                  ItemJnlLine.Validate("Unit of Measure Code","Unit of Measure Code");
                ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                ItemJnlLine.Description := Description;
                ItemJnlLine.Validate(Quantity,QtyToPost);
                ItemJnlLine.Validate("Unit Cost","Unit Cost");
                ItemJnlLine."Location Code" := "Location Code";
                ItemJnlLine."Bin Code" := "Bin Code";
                ItemJnlLine."Variant Code" := "Variant Code";
                ItemJnlLine."Source Code" := SourceCodeSetup.Flushing;
                ItemJnlLine."Gen. Bus. Posting Group" := ProdOrder."Gen. Bus. Posting Group";
                ItemJnlLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                if Item."Item Tracking Code" <> '' then
                  ItemTrackingMgt.CopyItemTracking(RowID1,ItemJnlLine.RowID1,false);
                ItemJnlPostLine.Run(ItemJnlLine);
              end;
            until Next = 0;
            Window.Close;
          end;
        end;
    end;

    local procedure CheckBeforeFinishProdOrder(ProdOrder: Record "Production Order")
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        PurchLine: Record "Purchase Line";
        ShowWarning: Boolean;
    begin
        with PurchLine do begin
          SetCurrentkey("Document Type",Type,"Prod. Order No.","Prod. Order Line No.","Routing No.","Operation No.");
          SetRange("Document Type","document type"::Order);
          SetRange(Type,Type::Item);
          SetRange("Prod. Order No.",ProdOrder."No.");
          SetFilter("Outstanding Quantity",'<>%1',0);
          if FindFirst then
            Error(Text008,ProdOrder.TableCaption,ProdOrder."No.","Document No.");
        end;

        with ProdOrderLine do begin
          SetRange(Status,ProdOrder.Status);
          SetRange("Prod. Order No.",ProdOrder."No.");
          SetFilter("Remaining Quantity",'<>0');
          if not IsEmpty then begin
            ProdOrderRtngLine.SetRange(Status,ProdOrder.Status);
            ProdOrderRtngLine.SetRange("Prod. Order No.",ProdOrder."No.");
            ProdOrderRtngLine.SetRange("Next Operation No.",'');
            if not ProdOrderRtngLine.IsEmpty then begin
              ProdOrderRtngLine.SetFilter("Flushing Method",'<>%1',ProdOrderRtngLine."flushing method"::Backward);
              ShowWarning := not ProdOrderRtngLine.IsEmpty;
            end else
              ShowWarning := true;

            if ShowWarning then begin;
              if Confirm(StrSubstNo(Text004,ProdOrder.TableCaption,ProdOrder."No.")) then
                exit;
              Error(Text005);
            end;
          end;
        end;

        with ProdOrderComp do begin
          SetAutocalcFields("Pick Qty. (Base)");
          SetRange(Status,ProdOrder.Status);
          SetRange("Prod. Order No.",ProdOrder."No.");
          SetFilter("Remaining Quantity",'<>0');
          if FindSet then
            repeat
              TestField("Pick Qty. (Base)",0);
              if (("Flushing Method" <> "flushing method"::Backward) and
                  ("Flushing Method" <> "flushing method"::"Pick + Backward") and
                  ("Routing Link Code" = '')) or
                 (("Routing Link Code" <> '') and not RtngWillFlushComp(ProdOrderComp))
              then begin
                if Confirm(StrSubstNo(Text006,ProdOrder.TableCaption,ProdOrder."No.")) then
                  exit;
                Error(Text005);
              end;
            until Next = 0;
        end;
    end;

    local procedure RtngWillFlushComp(ProdOrderComp: Record "Prod. Order Component"): Boolean
    var
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        if ProdOrderComp."Routing Link Code" = '' then
          exit;

        with ProdOrderComp do
          ProdOrderLine.Get(Status,"Prod. Order No.","Prod. Order Line No.");

        with ProdOrderRtngLine do begin
          SetCurrentkey("Prod. Order No.",Status,"Flushing Method");
          SetRange("Flushing Method","flushing method"::Backward);
          SetRange(Status,Status::Released);
          SetRange("Prod. Order No.",ProdOrderComp."Prod. Order No.");
          SetRange("Routing Link Code",ProdOrderComp."Routing Link Code");
          SetRange("Routing No.",ProdOrderLine."Routing No.");
          SetRange("Routing Reference No.",ProdOrderLine."Routing Reference No.");
          exit(FindFirst);
        end;
    end;

    local procedure GetSourceCodeSetup()
    begin
        if not SourceCodeSetupRead then
          SourceCodeSetup.Get;
        SourceCodeSetupRead := true;
    end;


    procedure SetPostingInfo(Status: Option Quote,Planned,"Firm Planned",Released,Finished;PostingDate: Date;UpdateUnitCost: Boolean)
    begin
        NewStatus := Status;
        NewPostingDate := PostingDate;
        NewUpdateUnitCost := UpdateUnitCost;
    end;

    local procedure ErrorIfUnableToClearWIP(ProdOrder: Record "Production Order")
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        ProdOrderLine.SetRange(Status,ProdOrder.Status);
        ProdOrderLine.SetRange("Prod. Order No.",ProdOrder."No.");
        if ProdOrderLine.FindSet then
          repeat
            if not OutputExists(ProdOrderLine) then
              if MatrOrCapConsumpExists(ProdOrderLine) then
                Error(Text009,ProdOrderLine."Line No.",ToProdOrder.TableCaption,ProdOrderLine."Prod. Order No.");
          until ProdOrderLine.Next = 0;
    end;

    local procedure OutputExists(ProdOrderLine: Record "Prod. Order Line"): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.SetCurrentkey("Order Type","Order No.","Order Line No.");
        ItemLedgEntry.SetRange("Order Type",ItemLedgEntry."order type"::Production);
        ItemLedgEntry.SetRange("Order No.",ProdOrderLine."Prod. Order No.");
        ItemLedgEntry.SetRange("Order Line No.",ProdOrderLine."Line No.");
        ItemLedgEntry.SetRange("Entry Type",ItemLedgEntry."entry type"::Output);
        if ItemLedgEntry.FindFirst then begin
          ItemLedgEntry.CalcSums(Quantity);
          if ItemLedgEntry.Quantity <> 0 then
            exit(true)
        end;
        exit(false);
    end;

    local procedure MatrOrCapConsumpExists(ProdOrderLine: Record "Prod. Order Line"): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        CapLedgEntry: Record "Capacity Ledger Entry";
    begin
        ItemLedgEntry.SetCurrentkey("Order Type","Order No.","Order Line No.");
        ItemLedgEntry.SetRange("Order Type",ItemLedgEntry."order type"::Production);
        ItemLedgEntry.SetRange("Order No.",ProdOrderLine."Prod. Order No.");
        ItemLedgEntry.SetRange("Order Line No.",ProdOrderLine."Line No.");
        ItemLedgEntry.SetRange("Entry Type",ItemLedgEntry."entry type"::Consumption);
        if not ItemLedgEntry.IsEmpty then
          exit(true);

        CapLedgEntry.SetCurrentkey("Order Type","Order No.","Order Line No.","Routing No.","Routing Reference No.");
        CapLedgEntry.SetRange("Order Type",CapLedgEntry."order type"::Production);
        CapLedgEntry.SetRange("Order No.",ProdOrderLine."Prod. Order No.");
        CapLedgEntry.SetRange("Routing No.",ProdOrderLine."Routing No.");
        CapLedgEntry.SetRange("Routing Reference No.",ProdOrderLine."Routing Reference No.");
        exit(not CapLedgEntry.IsEmpty);
    end;

    local procedure SetTimeAndQuantityOmItemJnlLine(var ItemJnlLine: Record "Item Journal Line";ProdOrderRtngLine: Record "Prod. Order Routing Line";OutputQtyBase: Decimal;OutputQty: Decimal)
    var
        CostCalculationManagement: Codeunit "Cost Calculation Management";
    begin
        if ItemJnlLine.SubcontractingWorkCenterUsed then begin
          ItemJnlLine.Validate("Output Quantity",0);
          ItemJnlLine.Validate("Run Time",0);
          ItemJnlLine.Validate("Setup Time",0)
        end else begin
          ItemJnlLine.Validate(
            "Setup Time",
            ROUND(
              ProdOrderRtngLine."Setup Time" *
              ProdOrderRtngLine."Concurrent Capacities" *
              CalendarMgt.QtyperTimeUnitofMeasure(
                ProdOrderRtngLine."Work Center No.",
                ProdOrderRtngLine."Setup Time Unit of Meas. Code"),
              0.00001));
          ItemJnlLine.Validate(
            "Run Time",
            CostCalculationManagement.CalcCostTime(
              OutputQtyBase,
              ProdOrderRtngLine."Setup Time",ProdOrderRtngLine."Setup Time Unit of Meas. Code",
              ProdOrderRtngLine."Run Time",ProdOrderRtngLine."Run Time Unit of Meas. Code",
              ProdOrderRtngLine."Lot Size",
              ProdOrderRtngLine."Scrap Factor % (Accumulated)",ProdOrderRtngLine."Fixed Scrap Qty. (Accum.)",
              ProdOrderRtngLine."Work Center No.",0,false,0));
          ItemJnlLine.Validate("Output Quantity",OutputQty);
        end;
    end;
}

