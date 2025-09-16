#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5818 "Undo Service Shipment Line"
{
    Permissions = TableData "Item Application Entry"=rmd,
                  TableData "Reservation Worksheet Log"=imd,
                  TableData "Service Line"=imd,
                  TableData "Service Ledger Entry"=i,
                  TableData "Warranty Ledger Entry"=im,
                  TableData "Service Shipment Line"=imd,
                  TableData "Item Entry Relation"=ri;
    TableNo = "Service Shipment Line";

    trigger OnRun()
    var
        ConfMessage: Text[250];
    begin
        if not Find('-') then
          exit;

        ConfMessage := Text000;

        if CheckComponentsAdjusted(Rec) then
          ConfMessage :=
            StrSubstNo(Text004,FieldCaption("Service Item No."),Format("Service Item No.")) +
            Text000;

        if not HideDialog then
          if not Confirm(ConfMessage) then
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
        InvtSetup: Record "Inventory Setup";
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        WhseUndoQty: Codeunit "Whse. Undo Quantity";
        UndoPostingMgt: Codeunit "Undo Posting Management";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        Text000: label 'Do you want to undo the selected shipment line(s)?';
        Text001: label 'Undo quantity posting...';
        Text002: label 'There is not enough space to insert correction lines.';
        InvtAdjmt: Codeunit "Inventory Adjustment";
        Text003: label 'Checking lines...';
        NextLineNo: Integer;
        HideDialog: Boolean;
        Text004: label 'The component list for %1 %2 was changed. You may need to adjust the list manually.\';
        Text005: label 'Some shipment lines may have unused service items. Do you want to delete them?';

    local procedure CheckComponentsAdjusted(var ServiceShptLine: Record "Service Shipment Line"): Boolean
    var
        LocalServShptLine: Record "Service Shipment Line";
    begin
        LocalServShptLine.Copy(ServiceShptLine);
        with LocalServShptLine do begin
          SetFilter("Spare Part Action",'%1|%2',
            "spare part action"::"Component Replaced","spare part action"::"Component Installed");
          SetFilter("Service Item No.",'<>%1','');
          exit(not IsEmpty);
        end;
    end;


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
        DeleteServItems: Boolean;
        PostedWhseShptLineFound: Boolean;
    begin
        with ServShptLine do begin
          Clear(ItemJnlPostLine);
          SetRange(Correction,false);
          FindFirst;
          repeat
            if not HideDialog then
              Window.Open(Text003);
            CheckServShptLine(ServShptLine);
          until Next = 0;

          ServItem.SetCurrentkey("Sales/Serv. Shpt. Document No.");
          ServItem.SetRange("Sales/Serv. Shpt. Document No.","Document No.");
          ServItem.SetRange("Sales/Serv. Shpt. Line No.","Line No.");
          ServItem.SetRange("Shipment Type",ServItem."shipment type"::Service);

          if ServItem.FindFirst then
            if not HideDialog then
              DeleteServItems := Confirm(Text005,true)
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
                Database::"Service Shipment Line",
                "Document No.",
                Database::"Service Line",
                SalesLine."document type"::Order,
                "Order No.",
                "Order Line No.");

            if Type = Type::Item then
              ItemShptEntryNo := PostItemJnlLine(ServShptLine)
            else
              ItemShptEntryNo := 0;

            if Type = Type::Resource then
              PostResJnlLine(ServShptLine);

            InsertNewShipmentLine(ServShptLine,ItemShptEntryNo);
            if PostedWhseShptLineFound then
              WhseUndoQty.UndoPostedWhseShptLine(PostedWhseShptLine);
            InsertNewServiceEntry(ServShptLine);
            if Type in [Type::Item,Type::Resource] then
              InsertNewWarrantyEntry(ServShptLine);

            UpdateOrderLine(ServShptLine);
            if PostedWhseShptLineFound then
              WhseUndoQty.UpdateShptSourceDocLines(PostedWhseShptLine);

            if DeleteServItems then
              DeleteServShptLineServItems(ServShptLine);

            "Quantity Invoiced" := Quantity;
            "Qty. Invoiced (Base)" := "Quantity (Base)";
            "Qty. Shipped Not Invoiced" := 0;
            "Qty. Shipped Not Invd. (Base)" := 0;
            Correction := true;
            Modify;

          until Next = 0;

          InvtSetup.Get;
          if InvtSetup."Automatic Cost Adjustment" <>
             InvtSetup."automatic cost adjustment"::Never
          then begin
            ServShptHeader.Get("Document No.");
            InvtAdjmt.SetProperties(true,InvtSetup."Automatic Cost Posting");
            InvtAdjmt.SetJobUpdateProperties(true);
            InvtAdjmt.MakeMultiLevelAdjmt;
          end;
          WhseUndoQty.PostTempWhseJnlLine(TempWhseJnlLine);
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

    local procedure InsertNewServiceEntry(var ServShptLine: Record "Service Shipment Line")
    var
        ServLedgEntry: Record "Service Ledger Entry";
        NewServLedgEntry: Record "Service Ledger Entry";
        ServLedgEntriesPost: Codeunit "ServLedgEntries-Post";
        ServLedgEntryNo: Integer;
        WarrantyLedgEntryNo: Integer;
    begin
        ServLedgEntry.LockTable;
        if ServLedgEntry.Get(ServShptLine."Appl.-to Service Entry") then begin
          ServLedgEntriesPost.InitServiceRegister(ServLedgEntryNo,WarrantyLedgEntryNo);
          NewServLedgEntry := ServLedgEntry;
          NewServLedgEntry."Entry No." := ServLedgEntryNo;
          InvertServLedgEntry(NewServLedgEntry);
          NewServLedgEntry.Insert;
          ServLedgEntriesPost.FinishServiceRegister(ServLedgEntryNo,WarrantyLedgEntryNo);
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

    local procedure CheckServShptLine(var ServShptLine: Record "Service Shipment Line")
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
    begin
        with ServShptLine do begin
          TestField(Quantity);
          TestField("Qty. Shipped Not Invoiced",Quantity);
          UndoPostingMgt.TestServShptLine(ServShptLine);
          if Type = Type::Item then begin
            UndoPostingMgt.CollectItemLedgEntries(TempItemLedgEntry,Database::"Service Shipment Line",
              "Document No.","Line No.","Quantity (Base)","Item Shpt. Entry No.");
            UndoPostingMgt.CheckItemLedgEntries(TempItemLedgEntry,"Line No.");
          end;
        end;
    end;

    local procedure PostItemJnlLine(ServShptLine: Record "Service Shipment Line"): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
        ServLine: Record "Service Line";
        ServShptHeader: Record "Service Shipment Header";
        SourceCodeSetup: Record "Source Code Setup";
        TempApplyToEntryList: Record "Item Ledger Entry" temporary;
    begin
        with ServShptLine do begin
          SourceCodeSetup.Get;
          ServShptHeader.Get("Document No.");
          ItemJnlLine.Init;
          ItemJnlLine."Entry Type" := ItemJnlLine."entry type"::Sale;
          ItemJnlLine."Document Type" := ItemJnlLine."document type"::"Service Shipment";
          ItemJnlLine."Document No." := ServShptHeader."No.";
          ItemJnlLine."Document Line No." := "Line No." + GetCorrectiveShptLineNoStep("Document No.","Line No.");
          ItemJnlLine."Item No." := "No.";
          ItemJnlLine."Posting Date" := ServShptHeader."Posting Date";
          ItemJnlLine."Document No." := "Document No.";
          ItemJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
          ItemJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
          ItemJnlLine."Source Posting Group" := ServShptHeader."Customer Posting Group";
          ItemJnlLine."Salespers./Purch. Code" := ServShptHeader."Salesperson Code";
          ItemJnlLine."Country/Region Code" := ServShptHeader."Country/Region Code";
          ItemJnlLine."Posting No. Series" := ServShptHeader."No. Series";
          ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
          ItemJnlLine."Location Code" := "Location Code";
          ItemJnlLine."Source Code" := SourceCodeSetup.Sales;
          ItemJnlLine."Applies-to Entry" := "Item Shpt. Entry No.";
          ItemJnlLine.Correction := true;
          ItemJnlLine."Variant Code" := "Variant Code";
          ItemJnlLine."Bin Code" := "Bin Code";
          ItemJnlLine.Quantity := -"Quantity (Base)";
          ItemJnlLine."Quantity (Base)" := -"Quantity (Base)";
          ItemJnlLine."Document Date" := ServShptHeader."Document Date";

          WhseUndoQty.InsertTempWhseJnlLine(ItemJnlLine,
            Database::"Service Line",
            ServLine."document type"::Order,
            "Order No.",
            "Order Line No.",
            TempWhseJnlLine."reference document"::"Posted Shipment",
            TempWhseJnlLine,
            NextLineNo);

          if "Item Shpt. Entry No." <> 0 then begin
            ItemJnlPostLine.Run(ItemJnlLine);
            exit(ItemJnlLine."Item Shpt. Entry No.");
          end;
          UndoPostingMgt.CollectItemLedgEntries(TempApplyToEntryList,Database::"Service Shipment Line",
            "Document No.","Line No.","Quantity (Base)","Item Shpt. Entry No.");

          UndoPostingMgt.PostItemJnlLineAppliedToList(ItemJnlLine,TempApplyToEntryList,
            Quantity,"Quantity (Base)",TempGlobalItemLedgEntry,TempGlobalItemEntryRelation);

          exit(0); // "Item Shpt. Entry No."
        end;
    end;

    local procedure InsertNewShipmentLine(OldServShptLine: Record "Service Shipment Line";ItemShptEntryNo: Integer)
    var
        NewServShptLine: Record "Service Shipment Line";
    begin
        with OldServShptLine do begin
          NewServShptLine.Reset;
          NewServShptLine.Init;
          NewServShptLine.Copy(OldServShptLine);
          NewServShptLine."Line No." := "Line No." + GetCorrectiveShptLineNoStep("Document No.","Line No.");
          NewServShptLine."Item Shpt. Entry No." := ItemShptEntryNo;
          NewServShptLine."Appl.-to Service Entry" := "Appl.-to Service Entry";
          NewServShptLine.Quantity := -Quantity;
          NewServShptLine."Qty. Shipped Not Invoiced" := 0;
          NewServShptLine."Qty. Shipped Not Invd. (Base)" := 0;
          NewServShptLine."Quantity (Base)" := -"Quantity (Base)";
          NewServShptLine."Quantity Invoiced" := NewServShptLine.Quantity;
          NewServShptLine."Qty. Invoiced (Base)" := NewServShptLine."Quantity (Base)";
          NewServShptLine.Correction := true;
          NewServShptLine."Dimension Set ID" := "Dimension Set ID";
          NewServShptLine.Insert;

          InsertItemEntryRelation(TempGlobalItemEntryRelation,NewServShptLine);
        end;
    end;

    local procedure UpdateOrderLine(ServShptLine: Record "Service Shipment Line")
    var
        ServLine: Record "Service Line";
    begin
        with ServShptLine do begin
          ServLine.Get(ServLine."document type"::Order,"Order No.","Order Line No.");
          UndoPostingMgt.UpdateServLine(ServLine,Quantity,"Quantity (Base)",TempGlobalItemLedgEntry);
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

    local procedure InvertWarrantyLedgEntry(var WarrantyLedgEntry: Record "Warranty Ledger Entry")
    begin
        with WarrantyLedgEntry do begin
          Amount := -Amount;
          Quantity := -Quantity;
        end;
    end;

    local procedure PostResJnlLine(var ServiceShptLine: Record "Service Shipment Line")
    var
        ResJnlLine: Record "Res. Journal Line";
        SrcCodeSetup: Record "Source Code Setup";
        ServiceShptHeader: Record "Service Shipment Header";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        TimeSheetMgt: Codeunit "Time Sheet Management";
    begin
        ResJnlLine.Init;
        SrcCodeSetup.Get;
        with ResJnlLine do begin
          ServiceShptHeader.Get(ServiceShptLine."Document No.");
          "Entry Type" := "entry type"::Usage;
          "Document No." := ServiceShptLine."Document No.";
          "Posting Date" := ServiceShptHeader."Posting Date";
          "Document Date" := ServiceShptHeader."Document Date";
          "Resource No." := ServiceShptLine."No.";
          Description := ServiceShptLine.Description;
          "Work Type Code" := ServiceShptLine."Work Type Code";
          Quantity := -ServiceShptLine."Qty. Shipped Not Invoiced";
          "Unit Cost" := ServiceShptLine."Unit Cost (LCY)";
          "Total Cost" := ServiceShptLine."Unit Cost (LCY)" * Quantity;
          "Unit Price" := ServiceShptLine."Unit Price";
          "Total Price" := "Unit Price" * Quantity;
          "Shortcut Dimension 1 Code" := ServiceShptHeader."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := ServiceShptHeader."Shortcut Dimension 2 Code";
          "Dimension Set ID" := ServiceShptLine."Dimension Set ID";
          "Unit of Measure Code" := ServiceShptLine."Unit of Measure Code";
          "Qty. per Unit of Measure" := ServiceShptLine."Qty. per Unit of Measure";
          "Source Code" := SrcCodeSetup."Service Management";
          "Gen. Bus. Posting Group" := ServiceShptLine."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := ServiceShptLine."Gen. Prod. Posting Group";
          "Posting No. Series" := ServiceShptHeader."No. Series";
          "Reason Code" := ServiceShptHeader."Reason Code";
          "Source Type" := "source type"::Customer;
          "Source No." := ServiceShptLine."Bill-to Customer No.";

          "Qty. per Unit of Measure" := ServiceShptLine."Qty. per Unit of Measure";
          ResJnlPostLine.RunWithCheck(ResJnlLine);
        end;

        TimeSheetMgt.CreateTSLineFromServiceShptLine(ServiceShptLine);
    end;

    local procedure DeleteServShptLineServItems(ServShptLine: Record "Service Shipment Line")
    var
        ServItem: Record "Service Item";
    begin
        ServItem.SetCurrentkey("Sales/Serv. Shpt. Document No.","Sales/Serv. Shpt. Line No.");
        ServItem.SetRange("Sales/Serv. Shpt. Document No.",ServShptLine."Document No.");
        ServItem.SetRange("Sales/Serv. Shpt. Line No.",ServShptLine."Line No.");
        ServItem.SetRange("Shipment Type",ServItem."shipment type"::Service);
        if ServItem.Find('-') then
          repeat
            if ServItem.CheckIfCanBeDeleted = '' then
              if ServItem.Delete(true) then;
          until ServItem.Next = 0;
    end;
}

