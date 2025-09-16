#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5813 "Undo Purchase Receipt Line"
{
    Permissions = TableData "Purchase Line"=imd,
                  TableData "Purch. Rcpt. Line"=imd,
                  TableData "Reservation Worksheet Log"=imd,
                  TableData "Item Entry Relation"=ri,
                  TableData "Whse. Item Entry Relation"=rimd;
    TableNo = "Purch. Rcpt. Line";

    trigger OnRun()
    begin
        SetRange(Type,Type::Item);
        if not Find('-') then
          Error(Text005);

        if not HideDialog then
          if not Confirm(Text000) then
            exit;

        PurchRcptLine.Copy(Rec);
        Code;
        Rec := PurchRcptLine;
    end;

    var
        Text000: label 'Do you really want to undo the selected Receipt lines?';
        Text001: label 'Undo quantity posting...';
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        TempGlobalItemLedgEntry: Record "Item Ledger Entry" temporary;
        TempGlobalItemEntryRelation: Record "Item Entry Relation" temporary;
        InvtSetup: Record "Inventory Setup";
        UndoPostingMgt: Codeunit "Undo Posting Management";
        Text002: label 'There is not enough space to insert correction lines.';
        WhseUndoQty: Codeunit "Whse. Undo Quantity";
        InvtAdjmt: Codeunit "Inventory Adjustment";
        HideDialog: Boolean;
        JobItem: Boolean;
        Text003: label 'Checking lines...';
        NextLineNo: Integer;
        Text004: label 'This receipt has already been invoiced. Undo Receipt can be applied only to posted, but not invoiced receipts.';
        Text005: label 'Undo Receipt can be performed only for lines of type Item. Please select a line of the Item type and repeat the procedure.';


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    local procedure "Code"()
    var
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        PurchLine: Record "Purchase Line";
        Window: Dialog;
        ItemRcptEntryNo: Integer;
        DocLineNo: Integer;
        PostedWhseRcptLineFound: Boolean;
    begin
        with PurchRcptLine do begin
          SetRange(Correction,false);

          repeat
            if not HideDialog then
              Window.Open(Text003);
            CheckPurchRcptLine(PurchRcptLine);
          until Next = 0;

          Find('-');
          repeat
            TempGlobalItemLedgEntry.Reset;
            if not TempGlobalItemLedgEntry.IsEmpty then
              TempGlobalItemLedgEntry.DeleteAll;
            TempGlobalItemEntryRelation.Reset;
            if not TempGlobalItemEntryRelation.IsEmpty then
              TempGlobalItemEntryRelation.DeleteAll;

            if not HideDialog then
              Window.Open(Text001);

            PostedWhseRcptLineFound :=
              WhseUndoQty.FindPostedWhseRcptLine(
                PostedWhseRcptLine,
                Database::"Purch. Rcpt. Line",
                "Document No.",
                Database::"Purchase Line",
                PurchLine."document type"::Order,
                "Order No.",
                "Order Line No.");

            ItemRcptEntryNo := PostItemJnlLine(PurchRcptLine,DocLineNo);

            InsertNewReceiptLine(PurchRcptLine,ItemRcptEntryNo,DocLineNo);
            if PostedWhseRcptLineFound then
              WhseUndoQty.UndoPostedWhseRcptLine(PostedWhseRcptLine);

            UpdateOrderLine(PurchRcptLine);
            if PostedWhseRcptLineFound then
              WhseUndoQty.UpdateRcptSourceDocLines(PostedWhseRcptLine);

            if ("Blanket Order No." <> '') and ("Blanket Order Line No." <> 0) then
              UpdateBlanketOrder(PurchRcptLine);

            "Quantity Invoiced" := Quantity;
            "Qty. Invoiced (Base)" := "Quantity (Base)";
            "Qty. Rcd. Not Invoiced" := 0;
            Correction := true;

            Modify;

            if not JobItem then
              JobItem := (Type = Type::Item) and ("Job No." <> '');
          until Next = 0;

          InvtSetup.Get;
          if InvtSetup."Automatic Cost Adjustment" <>
             InvtSetup."automatic cost adjustment"::Never
          then begin
            InvtAdjmt.SetProperties(true,InvtSetup."Automatic Cost Posting");
            InvtAdjmt.SetJobUpdateProperties(not JobItem);
            InvtAdjmt.MakeMultiLevelAdjmt;
          end;

          WhseUndoQty.PostTempWhseJnlLine(TempWhseJnlLine);
        end;
    end;

    local procedure CheckPurchRcptLine(PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
    begin
        with PurchRcptLine do begin
          TestField(Type,Type::Item);
          if "Qty. Rcd. Not Invoiced" <> Quantity then
            Error(Text004);
          TestField("Prod. Order No.",'');
          TestField("Sales Order No.",'');
          TestField("Sales Order Line No.",0);

          UndoPostingMgt.TestPurchRcptLine(PurchRcptLine);
          UndoPostingMgt.CollectItemLedgEntries(TempItemLedgEntry,Database::"Purch. Rcpt. Line",
            "Document No.","Line No.","Quantity (Base)","Item Rcpt. Entry No.");
          UndoPostingMgt.CheckItemLedgEntries(TempItemLedgEntry,"Line No.");
        end;
    end;

    local procedure PostItemJnlLine(PurchRcptLine: Record "Purch. Rcpt. Line";var DocLineNo: Integer): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
        PurchLine: Record "Purchase Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine2: Record "Purch. Rcpt. Line";
        SourceCodeSetup: Record "Source Code Setup";
        TempApplyToEntryList: Record "Item Ledger Entry" temporary;
        LineSpacing: Integer;
    begin
        with PurchRcptLine do begin
          PurchRcptLine2.SetRange("Document No.","Document No.");
          PurchRcptLine2."Document No." := "Document No.";
          PurchRcptLine2."Line No." := "Line No.";
          PurchRcptLine2.Find('=');

          if PurchRcptLine2.Find('>') then begin
            LineSpacing := (PurchRcptLine2."Line No." - "Line No.") DIV 2;
            if LineSpacing = 0 then
              Error(Text002);
          end else
            LineSpacing := 10000;
          DocLineNo := "Line No." + LineSpacing;

          SourceCodeSetup.Get;
          PurchRcptHeader.Get("Document No.");
          ItemJnlLine.Init;
          ItemJnlLine."Entry Type" := ItemJnlLine."entry type"::Purchase;
          ItemJnlLine."Item No." := "No.";
          ItemJnlLine."Posting Date" := PurchRcptHeader."Posting Date";
          ItemJnlLine."Document No." := "Document No.";
          ItemJnlLine."Document Line No." := DocLineNo;
          ItemJnlLine."Document Type" := ItemJnlLine."document type"::"Purchase Receipt";
          ItemJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
          ItemJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
          ItemJnlLine."Location Code" := "Location Code";
          ItemJnlLine."Source Code" := SourceCodeSetup.Purchases;
          ItemJnlLine."Variant Code" := "Variant Code";
          ItemJnlLine."Bin Code" := "Bin Code";
          ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
          ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          ItemJnlLine."Document Date" := PurchRcptHeader."Document Date";
          ItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
          ItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
          ItemJnlLine."Dimension Set ID" := "Dimension Set ID";

          if "Job No." = '' then begin
            ItemJnlLine.Correction := true;
            ItemJnlLine."Applies-to Entry" := "Item Rcpt. Entry No.";
          end else begin
            ItemJnlLine."Job No." := "Job No.";
            ItemJnlLine."Job Task No." := "Job Task No.";
            ItemJnlLine."Job Purchase" := true;
            ItemJnlLine."Unit Cost" := "Unit Cost (LCY)";
          end;
          ItemJnlLine.Quantity := -Quantity;
          ItemJnlLine."Quantity (Base)" := -"Quantity (Base)";

          WhseUndoQty.InsertTempWhseJnlLine(ItemJnlLine,
            Database::"Purchase Line",
            PurchLine."document type"::Order,
            "Order No.",
            "Line No.",
            TempWhseJnlLine."reference document"::"Posted Rcpt.",
            TempWhseJnlLine,
            NextLineNo);

          if "Item Rcpt. Entry No." <> 0 then begin
            if "Job No." <> '' then
              UndoPostingMgt.TransferSourceValues(ItemJnlLine,"Item Rcpt. Entry No.");
            UndoPostingMgt.PostItemJnlLine(ItemJnlLine);
            if "Job No." <> '' then
              UndoPostingMgt.ReapplyJobConsumption("Item Rcpt. Entry No.");

            exit(ItemJnlLine."Item Shpt. Entry No.");
          end;

          UndoPostingMgt.CollectItemLedgEntries(
            TempApplyToEntryList,Database::"Purch. Rcpt. Line","Document No.","Line No.","Quantity (Base)","Item Rcpt. Entry No.");

          if "Job No." <> '' then
            if TempApplyToEntryList.FindSet then
              repeat
                UndoPostingMgt.ReapplyJobConsumption(TempApplyToEntryList."Entry No.");
              until TempApplyToEntryList.Next = 0;

          UndoPostingMgt.PostItemJnlLineAppliedToList(ItemJnlLine,TempApplyToEntryList,
            Quantity,"Quantity (Base)",TempGlobalItemLedgEntry,TempGlobalItemEntryRelation);

          exit(0); // "Item Shpt. Entry No."
        end;
    end;

    local procedure InsertNewReceiptLine(OldPurchRcptLine: Record "Purch. Rcpt. Line";ItemRcptEntryNo: Integer;DocLineNo: Integer)
    var
        NewPurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        with OldPurchRcptLine do begin
          NewPurchRcptLine.Init;
          NewPurchRcptLine.Copy(OldPurchRcptLine);
          NewPurchRcptLine."Line No." := DocLineNo;
          NewPurchRcptLine."Appl.-to Item Entry" := "Item Rcpt. Entry No.";
          NewPurchRcptLine."Item Rcpt. Entry No." := ItemRcptEntryNo;
          NewPurchRcptLine.Quantity := -Quantity;
          NewPurchRcptLine."Quantity (Base)" := -"Quantity (Base)";
          NewPurchRcptLine."Quantity Invoiced" := NewPurchRcptLine.Quantity;
          NewPurchRcptLine."Qty. Invoiced (Base)" := NewPurchRcptLine."Quantity (Base)";
          NewPurchRcptLine."Qty. Rcd. Not Invoiced" := 0;
          NewPurchRcptLine.Correction := true;
          NewPurchRcptLine."Dimension Set ID" := "Dimension Set ID";
          NewPurchRcptLine.Insert;

          InsertItemEntryRelation(TempGlobalItemEntryRelation,NewPurchRcptLine);
        end;
    end;

    local procedure UpdateOrderLine(PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        PurchLine: Record "Purchase Line";
    begin
        with PurchRcptLine do begin
          PurchLine.Get(PurchLine."document type"::Order,"Order No.","Order Line No.");
          UndoPostingMgt.UpdatePurchLine(PurchLine,Quantity,"Quantity (Base)",TempGlobalItemLedgEntry);
        end;
    end;

    local procedure UpdateBlanketOrder(PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        BlanketOrderPurchaseLine: Record "Purchase Line";
    begin
        with PurchRcptLine do
          if BlanketOrderPurchaseLine.Get(
               BlanketOrderPurchaseLine."document type"::"Blanket Order","Blanket Order No.","Blanket Order Line No.")
          then begin
            BlanketOrderPurchaseLine.TestField(Type,Type);
            BlanketOrderPurchaseLine.TestField("No.","No.");
            BlanketOrderPurchaseLine.TestField("Buy-from Vendor No.","Buy-from Vendor No.");

            if BlanketOrderPurchaseLine."Qty. per Unit of Measure" = "Qty. per Unit of Measure" then
              BlanketOrderPurchaseLine."Quantity Received" := BlanketOrderPurchaseLine."Quantity Received" - Quantity
            else
              BlanketOrderPurchaseLine."Quantity Received" :=
                BlanketOrderPurchaseLine."Quantity Received" -
                ROUND("Qty. per Unit of Measure" / BlanketOrderPurchaseLine."Qty. per Unit of Measure" * Quantity,0.00001);

            BlanketOrderPurchaseLine."Qty. Received (Base)" := BlanketOrderPurchaseLine."Qty. Received (Base)" - "Quantity (Base)";
            BlanketOrderPurchaseLine.InitOutstanding;
            BlanketOrderPurchaseLine.Modify;
          end;
    end;

    local procedure InsertItemEntryRelation(var TempItemEntryRelation: Record "Item Entry Relation" temporary;NewPurchRcptLine: Record "Purch. Rcpt. Line")
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        if TempItemEntryRelation.Find('-') then
          repeat
            ItemEntryRelation := TempItemEntryRelation;
            ItemEntryRelation.TransferFieldsPurchRcptLine(NewPurchRcptLine);
            ItemEntryRelation.Insert;
          until TempItemEntryRelation.Next = 0;
    end;
}

