#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5815 "Undo Sales Shipment Line"
{
    Permissions = TableData "Sales Line"=imd,
                  TableData "Sales Shipment Line"=imd,
                  TableData "Item Application Entry"=rmd,
                  TableData "Reservation Worksheet Log"=imd,
                  TableData "Item Entry Relation"=ri;
    TableNo = "Sales Shipment Line";

    trigger OnRun()
    var
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
    begin
        SetRange(Type,Type::Item);
        SetFilter(Quantity,'<>0');
        if not Find('-') then
          Error(Text006);

        if not HideDialog then
          if not Confirm(Text000) then
            exit;

        SalesShptLine.Copy(Rec);
        Code;
        UpdateItemAnalysisView.UpdateAll(0,true);
        Rec := SalesShptLine;
    end;

    var
        SalesShptLine: Record "Sales Shipment Line";
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        TempGlobalItemLedgEntry: Record "Item Ledger Entry" temporary;
        TempGlobalItemEntryRelation: Record "Item Entry Relation" temporary;
        InvtSetup: Record "Inventory Setup";
        UndoPostingMgt: Codeunit "Undo Posting Management";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        Text000: label 'Do you really want to undo the selected Shipment lines?';
        Text001: label 'Undo quantity posting...';
        Text002: label 'There is not enough space to insert correction lines.';
        WhseUndoQty: Codeunit "Whse. Undo Quantity";
        InvtAdjmt: Codeunit "Inventory Adjustment";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line";
        AsmPost: Codeunit "Assembly-Post";
        ATOWindow: Dialog;
        HideDialog: Boolean;
        Text003: label 'Checking lines...';
        Text004: label 'Some shipment lines may have unused service items. Do you want to delete them?';
        NextLineNo: Integer;
        Text005: label 'This shipment has already been invoiced. Undo Shipment can be applied only to posted, but not invoiced shipments.';
        Text006: label 'Undo Shipment can be performed only for lines of type Item. Please select a line of the Item type and repeat the procedure.';
        Text055: label '#1#################################\\Checking Undo Assembly #2###########.';
        Text056: label '#1#################################\\Posting Undo Assembly #2###########.';
        Text057: label '#1#################################\\Finalizing Undo Assembly #2###########.';
        Text059: label '%1 %2 %3', Comment='%1 = SalesShipmentLine."Document No.". %2 = SalesShipmentLine.FIELDCAPTION("Line No."). %3 = SalesShipmentLine."Line No.". This is used in a progress window.';


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    local procedure "Code"()
    var
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        SalesLine: Record "Sales Line";
        ServItem: Record "Service Item";
        Window: Dialog;
        ItemShptEntryNo: Integer;
        DocLineNo: Integer;
        DeleteServItems: Boolean;
        PostedWhseShptLineFound: Boolean;
    begin
        with SalesShptLine do begin
          Clear(ItemJnlPostLine);
          SetCurrentkey("Item Shpt. Entry No.");
          SetRange(Correction,false);

          repeat
            if not HideDialog then
              Window.Open(Text003);
            CheckSalesShptLine(SalesShptLine);
          until Next = 0;

          ServItem.SetCurrentkey("Sales/Serv. Shpt. Document No.");
          ServItem.SetRange("Sales/Serv. Shpt. Document No.","Document No.");
          if ServItem.FindFirst then
            if not HideDialog then
              DeleteServItems := Confirm(Text004,true)
            else
              DeleteServItems := true;

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

            PostedWhseShptLineFound :=
              WhseUndoQty.FindPostedWhseShptLine(
                PostedWhseShptLine,
                Database::"Sales Shipment Line",
                "Document No.",
                Database::"Sales Line",
                SalesLine."document type"::Order,
                "Order No.",
                "Order Line No.");

            Clear(ItemJnlPostLine);
            ItemShptEntryNo := PostItemJnlLine(SalesShptLine,DocLineNo);

            InsertNewShipmentLine(SalesShptLine,ItemShptEntryNo,DocLineNo);

            if PostedWhseShptLineFound then
              WhseUndoQty.UndoPostedWhseShptLine(PostedWhseShptLine);

            TempWhseJnlLine.SetRange("Source Line No.","Line No.");
            WhseUndoQty.PostTempWhseJnlLine(TempWhseJnlLine);

            UndoPostATO(SalesShptLine);

            UpdateOrderLine(SalesShptLine);
            if PostedWhseShptLineFound then
              WhseUndoQty.UpdateShptSourceDocLines(PostedWhseShptLine);

            if ("Blanket Order No." <> '') and ("Blanket Order Line No." <> 0) then
              UpdateBlanketOrder(SalesShptLine);

            if DeleteServItems then
              DeleteSalesShptLineServItems(SalesShptLine);

            "Quantity Invoiced" := Quantity;
            "Qty. Invoiced (Base)" := "Quantity (Base)";
            "Qty. Shipped Not Invoiced" := 0;
            Correction := true;
            Modify;

            UndoFinalizePostATO(SalesShptLine);
          until Next = 0;

          InvtSetup.Get;
          if InvtSetup."Automatic Cost Adjustment" <>
             InvtSetup."automatic cost adjustment"::Never
          then begin
            InvtAdjmt.SetProperties(true,InvtSetup."Automatic Cost Posting");
            InvtAdjmt.SetJobUpdateProperties(true);
            InvtAdjmt.MakeMultiLevelAdjmt;
          end;
        end;
    end;

    local procedure CheckSalesShptLine(SalesShptLine: Record "Sales Shipment Line")
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
    begin
        with SalesShptLine do begin
          TestField(Type,Type::Item);
          if "Qty. Shipped Not Invoiced" <> Quantity then
            Error(Text005);
          TestField("Drop Shipment",false);

          UndoPostingMgt.TestSalesShptLine(SalesShptLine);
          UndoPostingMgt.CollectItemLedgEntries(TempItemLedgEntry,Database::"Sales Shipment Line",
            "Document No.","Line No.","Quantity (Base)","Item Shpt. Entry No.");
          UndoPostingMgt.CheckItemLedgEntries(TempItemLedgEntry,"Line No.");

          UndoInitPostATO(SalesShptLine);
        end;
    end;

    local procedure PostItemJnlLine(SalesShptLine: Record "Sales Shipment Line";var DocLineNo: Integer): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
        SalesLine: Record "Sales Line";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine2: Record "Sales Shipment Line";
        SourceCodeSetup: Record "Source Code Setup";
        TempApplyToEntryList: Record "Item Ledger Entry" temporary;
        ItemLedgEntryNotInvoiced: Record "Item Ledger Entry";
        LineSpacing: Integer;
        RemQtyBase: Decimal;
    begin
        with SalesShptLine do begin
          SalesShptLine2.SetRange("Document No.","Document No.");
          SalesShptLine2."Document No." := "Document No.";
          SalesShptLine2."Line No." := "Line No.";
          SalesShptLine2.Find('=');

          if SalesShptLine2.Find('>') then begin
            LineSpacing := (SalesShptLine2."Line No." - "Line No.") DIV 2;
            if LineSpacing = 0 then
              Error(Text002);
          end else
            LineSpacing := 10000;
          DocLineNo := "Line No." + LineSpacing;

          SourceCodeSetup.Get;
          SalesShptHeader.Get("Document No.");

          ItemJnlLine.Init;
          ItemJnlLine."Entry Type" := ItemJnlLine."entry type"::Sale;
          ItemJnlLine."Item No." := "No.";
          ItemJnlLine."Posting Date" := SalesShptHeader."Posting Date";
          ItemJnlLine."Document No." := "Document No.";
          ItemJnlLine."Document Line No." := DocLineNo;
          ItemJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
          ItemJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
          ItemJnlLine."Location Code" := "Location Code";
          ItemJnlLine."Source Code" := SourceCodeSetup.Sales;
          ItemJnlLine.Correction := true;
          ItemJnlLine."Variant Code" := "Variant Code";
          ItemJnlLine."Bin Code" := "Bin Code";
          ItemJnlLine."Document Date" := SalesShptHeader."Document Date";

          WhseUndoQty.InsertTempWhseJnlLine(ItemJnlLine,
            Database::"Sales Line",
            SalesLine."document type"::Order,
            "Order No.",
            "Order Line No.",
            TempWhseJnlLine."reference document"::"Posted Shipment",
            TempWhseJnlLine,
            NextLineNo);

          RemQtyBase := -"Quantity (Base)";
          if GetUnvoicedShptEntries(SalesShptLine,ItemLedgEntryNotInvoiced) then begin
            repeat
              ItemJnlLine."Applies-to Entry" := ItemLedgEntryNotInvoiced."Entry No.";
              ItemJnlLine.Quantity := ItemLedgEntryNotInvoiced.Quantity;
              ItemJnlLine."Quantity (Base)" := ItemLedgEntryNotInvoiced.Quantity;
              ItemJnlPostLine.Run(ItemJnlLine);
              RemQtyBase -= ItemJnlLine.Quantity;
              if ItemLedgEntryNotInvoiced.Next = 0 then;
            until (RemQtyBase = 0);
            exit(ItemJnlLine."Item Shpt. Entry No.");
          end;
          UndoPostingMgt.CollectItemLedgEntries(TempApplyToEntryList,Database::"Sales Shipment Line",
            "Document No.","Line No.","Quantity (Base)","Item Shpt. Entry No.");

          UndoPostingMgt.PostItemJnlLineAppliedToList(ItemJnlLine,TempApplyToEntryList,
            Quantity,"Quantity (Base)",TempGlobalItemLedgEntry,TempGlobalItemEntryRelation);

          exit(0); // "Item Shpt. Entry No."
        end;
    end;

    local procedure InsertNewShipmentLine(OldSalesShptLine: Record "Sales Shipment Line";ItemShptEntryNo: Integer;DocLineNo: Integer)
    var
        NewSalesShptLine: Record "Sales Shipment Line";
    begin
        with OldSalesShptLine do begin
          NewSalesShptLine.Init;
          NewSalesShptLine.Copy(OldSalesShptLine);
          NewSalesShptLine."Line No." := DocLineNo;
          NewSalesShptLine."Appl.-from Item Entry" := "Item Shpt. Entry No.";
          NewSalesShptLine."Item Shpt. Entry No." := ItemShptEntryNo;
          NewSalesShptLine.Quantity := -Quantity;
          NewSalesShptLine."Qty. Shipped Not Invoiced" := 0;
          NewSalesShptLine."Quantity (Base)" := -"Quantity (Base)";
          NewSalesShptLine."Quantity Invoiced" := NewSalesShptLine.Quantity;
          NewSalesShptLine."Qty. Invoiced (Base)" := NewSalesShptLine."Quantity (Base)";
          NewSalesShptLine.Correction := true;
          NewSalesShptLine."Dimension Set ID" := "Dimension Set ID";
          NewSalesShptLine.Insert;

          InsertItemEntryRelation(TempGlobalItemEntryRelation,NewSalesShptLine);
        end;
    end;

    local procedure UpdateOrderLine(SalesShptLine: Record "Sales Shipment Line")
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesShptLine do begin
          SalesLine.Get(SalesLine."document type"::Order,"Order No.","Order Line No.");
          UndoPostingMgt.UpdateSalesLine(SalesLine,Quantity,"Quantity (Base)",TempGlobalItemLedgEntry);
        end;
    end;

    local procedure UpdateBlanketOrder(SalesShptLine: Record "Sales Shipment Line")
    var
        BlanketOrderSalesLine: Record "Sales Line";
        xBlanketOrderSalesLine: Record "Sales Line";
    begin
        with SalesShptLine do
          if BlanketOrderSalesLine.Get(
               BlanketOrderSalesLine."document type"::"Blanket Order","Blanket Order No.","Blanket Order Line No.")
          then begin
            BlanketOrderSalesLine.TestField(Type,Type);
            BlanketOrderSalesLine.TestField("No.","No.");
            BlanketOrderSalesLine.TestField("Sell-to Customer No.","Sell-to Customer No.");
            xBlanketOrderSalesLine := BlanketOrderSalesLine;

            if BlanketOrderSalesLine."Qty. per Unit of Measure" = "Qty. per Unit of Measure" then
              BlanketOrderSalesLine."Quantity Shipped" := BlanketOrderSalesLine."Quantity Shipped" - Quantity
            else
              BlanketOrderSalesLine."Quantity Shipped" :=
                BlanketOrderSalesLine."Quantity Shipped" -
                ROUND("Qty. per Unit of Measure" / BlanketOrderSalesLine."Qty. per Unit of Measure" * Quantity,0.00001);

            BlanketOrderSalesLine."Qty. Shipped (Base)" := BlanketOrderSalesLine."Qty. Shipped (Base)" - "Quantity (Base)";
            BlanketOrderSalesLine.InitOutstanding;
            BlanketOrderSalesLine.Modify;

            AsmPost.UpdateBlanketATO(xBlanketOrderSalesLine,BlanketOrderSalesLine);
          end;
    end;

    local procedure InsertItemEntryRelation(var TempItemEntryRelation: Record "Item Entry Relation" temporary;NewSalesShptLine: Record "Sales Shipment Line")
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        if TempItemEntryRelation.Find('-') then
          repeat
            ItemEntryRelation := TempItemEntryRelation;
            ItemEntryRelation.TransferFieldsSalesShptLine(NewSalesShptLine);
            ItemEntryRelation.Insert;
          until TempItemEntryRelation.Next = 0;
    end;

    local procedure DeleteSalesShptLineServItems(SalesShptLine: Record "Sales Shipment Line")
    var
        ServItem: Record "Service Item";
    begin
        ServItem.SetCurrentkey("Sales/Serv. Shpt. Document No.","Sales/Serv. Shpt. Line No.");
        ServItem.SetRange("Sales/Serv. Shpt. Document No.",SalesShptLine."Document No.");
        ServItem.SetRange("Sales/Serv. Shpt. Line No.",SalesShptLine."Line No.");
        ServItem.SetRange("Shipment Type",ServItem."shipment type"::Sales);
        if ServItem.Find('-') then
          repeat
            if ServItem.CheckIfCanBeDeleted = '' then
              if ServItem.Delete(true) then;
          until ServItem.Next = 0;
    end;

    local procedure UndoInitPostATO(var SalesShptLine: Record "Sales Shipment Line")
    var
        PostedAsmHeader: Record "Posted Assembly Header";
    begin
        if SalesShptLine.AsmToShipmentExists(PostedAsmHeader) then begin
          OpenATOProgressWindow(Text055,SalesShptLine,PostedAsmHeader);

          AsmPost.UndoInitPostATO(PostedAsmHeader);

          ATOWindow.Close;
        end;
    end;

    local procedure UndoPostATO(var SalesShptLine: Record "Sales Shipment Line")
    var
        PostedAsmHeader: Record "Posted Assembly Header";
    begin
        if SalesShptLine.AsmToShipmentExists(PostedAsmHeader) then begin
          OpenATOProgressWindow(Text056,SalesShptLine,PostedAsmHeader);

          AsmPost.UndoPostATO(PostedAsmHeader,ItemJnlPostLine,ResJnlPostLine,WhseJnlRegisterLine);

          ATOWindow.Close;
        end;
    end;

    local procedure UndoFinalizePostATO(var SalesShptLine: Record "Sales Shipment Line")
    var
        PostedAsmHeader: Record "Posted Assembly Header";
    begin
        if SalesShptLine.AsmToShipmentExists(PostedAsmHeader) then begin
          OpenATOProgressWindow(Text057,SalesShptLine,PostedAsmHeader);

          AsmPost.UndoFinalizePostATO(PostedAsmHeader);
          SynchronizeATO(SalesShptLine);

          ATOWindow.Close;
        end;
    end;

    local procedure SynchronizeATO(var SalesShptLine: Record "Sales Shipment Line")
    var
        SalesLine: Record "Sales Line";
        AsmHeader: Record "Assembly Header";
    begin
        with SalesLine do begin
          Get("document type"::Order,SalesShptLine."Order No.",SalesShptLine."Order Line No.");

          if AsmToOrderExists(AsmHeader) and (AsmHeader.Status = AsmHeader.Status::Released) then begin
            AsmHeader.Status := AsmHeader.Status::Open;
            AsmHeader.Modify;
            AutoAsmToOrder;
            AsmHeader.Status := AsmHeader.Status::Released;
            AsmHeader.Modify;
          end else
            AutoAsmToOrder;

          Modify(true);
        end;
    end;

    local procedure OpenATOProgressWindow(State: Text[250];SalesShptLine: Record "Sales Shipment Line";PostedAsmHeader: Record "Posted Assembly Header")
    begin
        ATOWindow.Open(State);
        ATOWindow.Update(1,
          StrSubstNo(Text059,
            SalesShptLine."Document No.",SalesShptLine.FieldCaption("Line No."),SalesShptLine."Line No."));
        ATOWindow.Update(2,PostedAsmHeader."No.");
    end;

    local procedure GetUnvoicedShptEntries(SalesShptLine: Record "Sales Shipment Line";var ItemLedgEntry: Record "Item Ledger Entry"): Boolean
    begin
        ItemLedgEntry.SetCurrentkey("Document No.","Document Type","Document Line No.");
        ItemLedgEntry.SetRange("Document Type",ItemLedgEntry."document type"::"Sales Shipment");
        ItemLedgEntry.SetRange("Document No.",SalesShptLine."Document No.");
        ItemLedgEntry.SetRange("Document Line No.",SalesShptLine."Line No.");
        ItemLedgEntry.SetRange("Serial No.",'');
        ItemLedgEntry.SetRange("Lot No.",'');
        ItemLedgEntry.SetRange("Completely Invoiced",false);
        exit(ItemLedgEntry.FindSet)
    end;
}

