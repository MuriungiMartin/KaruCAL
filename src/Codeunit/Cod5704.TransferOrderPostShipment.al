#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5704 "TransferOrder-Post Shipment"
{
    Permissions = TableData "Item Entry Relation"=i;
    TableNo = "Transfer Header";

    trigger OnRun()
    var
        Item: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UpdateAnalysisView: Codeunit "Update Analysis View";
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        RecordLinkManagement: Codeunit "Record Link Management";
        Window: Dialog;
        LineCount: Integer;
        NextLineNo: Integer;
    begin
        if Status = Status::Open then begin
          Codeunit.Run(Codeunit::"Release Transfer Document",Rec);
          Status := Status::Open;
          Modify;
          Commit;
          Status := Status::Released;
        end;
        TransHeader := Rec;
        TransHeader.SetHideValidationDialog(HideValidationDialog);

        with TransHeader do begin
          CheckBeforePost;

          WhseReference := "Posting from Whse. Ref.";
          "Posting from Whse. Ref." := 0;

          if "Shipping Advice" = "shipping advice"::Complete then
            if not GetShippingAdvice then
              Error(Text008);

          CheckDim;

          TransLine.Reset;
          TransLine.SetRange("Document No.","No.");
          TransLine.SetRange("Derived From Line No.",0);
          TransLine.SetFilter(Quantity,'<>0');
          TransLine.SetFilter("Qty. to Ship",'<>0');
          if TransLine.IsEmpty then
            Error(Text001);

          WhseShip := TempWhseShptHeader.FindFirst;
          InvtPickPutaway := WhseReference <> 0;
          CheckItemInInventoryAndWarehouse(TransLine,not (WhseShip or InvtPickPutaway));

          GetLocation("Transfer-from Code");
          if Location."Bin Mandatory" and not (WhseShip or InvtPickPutaway) then
            WhsePosting := true;

          Window.Open(
            '#1#################################\\' +
            Text003);

          Window.Update(1,StrSubstNo(Text004,"No."));

          SourceCodeSetup.Get;
          SourceCode := SourceCodeSetup.Transfer;
          InvtSetup.Get;
          InvtSetup.TestField("Posted Transfer Shpt. Nos.");

          CheckInvtPostingSetup;

          LockTables(InvtSetup."Automatic Cost Posting");

          // Insert shipment header
          PostedWhseShptHeader.LockTable;
          TransShptHeader.LockTable;
          TransShptHeader.Init;
          TransShptHeader.CopyFromTransferHeader(TransHeader);
          TransShptHeader."No. Series" := InvtSetup."Posted Transfer Shpt. Nos.";
          TransShptHeader."No." :=
            NoSeriesMgt.GetNextNo(
              InvtSetup."Posted Transfer Shpt. Nos.","Posting Date",true);
          TransShptHeader.Insert;

          if InvtSetup."Copy Comments Order to Shpt." then begin
            CopyCommentLines(1,2,"No.",TransShptHeader."No.");
            RecordLinkManagement.CopyLinks(Rec,TransShptHeader);
          end;

          if WhseShip then begin
            WhseShptHeader.Get(TempWhseShptHeader."No.");
            WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,TransShptHeader."No.","Posting Date");
          end;

          // Insert shipment lines
          LineCount := 0;
          if WhseShip then
            PostedWhseShptLine.LockTable;
          if InvtPickPutaway then
            WhseRqst.LockTable;
          TransShptLine.LockTable;
          TransLine.SetRange(Quantity);
          TransLine.SetRange("Qty. to Ship");
          if TransLine.Find('-') then
            repeat
              LineCount := LineCount + 1;
              Window.Update(2,LineCount);

              if TransLine."Item No." <> '' then begin
                Item.Get(TransLine."Item No.");
                Item.TestField(Blocked,false);
              end;

              TransShptLine.Init;
              TransShptLine."Document No." := TransShptHeader."No.";
              TransShptLine.CopyFromTransferLine(TransLine);

              if TransLine."Qty. to Ship" > 0 then begin
                OriginalQuantity := TransLine."Qty. to Ship";
                OriginalQuantityBase := TransLine."Qty. to Ship (Base)";
                PostItemJnlLine(TransLine,TransShptHeader,TransShptLine);
                TransShptLine."Item Shpt. Entry No." := InsertShptEntryRelation(TransShptLine);
                if WhseShip then begin
                  WhseShptLine.SetCurrentkey(
                    "No.","Source Type","Source Subtype","Source No.","Source Line No.");
                  WhseShptLine.SetRange("No.",WhseShptHeader."No.");
                  WhseShptLine.SetRange("Source Type",Database::"Transfer Line");
                  WhseShptLine.SetRange("Source No.",TransLine."Document No.");
                  WhseShptLine.SetRange("Source Line No.",TransLine."Line No.");
                  WhseShptLine.FindFirst;
                  WhseShptLine.TestField("Qty. to Ship",TransShptLine.Quantity);
                  WhsePostShpt.CreatePostedShptLine(
                    WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
                end;
                if WhsePosting then
                  PostWhseJnlLine(ItemJnlLine,OriginalQuantity,OriginalQuantityBase);
              end;
              TransShptLine.Insert;
            until TransLine.Next = 0;

          InvtSetup.Get;
          if InvtSetup."Automatic Cost Adjustment" <> InvtSetup."automatic cost adjustment"::Never then begin
            InvtAdjmt.SetProperties(true,InvtSetup."Automatic Cost Posting");
            InvtAdjmt.MakeMultiLevelAdjmt;
          end;

          if WhseShip then
            WhseShptLine.LockTable;
          TransLine.LockTable;
          TransLine.SetFilter(Quantity,'<>0');
          TransLine.SetFilter("Qty. to Ship",'<>0');
          if TransLine.Find('-') then begin
            NextLineNo := AssignLineNo(TransLine."Document No.");
            repeat
              TransLine2.Init;
              TransLine2 := TransLine;
              TransLine2."Transfer-from Code" := TransLine."In-Transit Code";
              TransLine2."In-Transit Code" := '';
              TransLine2."Derived From Line No." := TransLine."Line No.";
              TransLine2."Line No." := NextLineNo;
              NextLineNo := NextLineNo + 10000;
              TransLine2.Quantity := TransLine."Qty. to Ship";
              TransLine2."Quantity (Base)" := TransLine."Qty. to Ship (Base)";
              TransLine2."Qty. to Ship" := TransLine2.Quantity;
              TransLine2."Qty. to Ship (Base)" := TransLine2."Quantity (Base)";
              TransLine2."Qty. to Receive" := TransLine2.Quantity;
              TransLine2."Qty. to Receive (Base)" := TransLine2."Quantity (Base)";
              TransLine2."Quantity Shipped" := 0;
              TransLine2."Qty. Shipped (Base)" := 0;
              TransLine2."Quantity Received" := 0;
              TransLine2."Qty. Received (Base)" := 0;
              TransLine2."Qty. in Transit" := 0;
              TransLine2."Qty. in Transit (Base)" := 0;
              TransLine2."Outstanding Quantity" := TransLine2.Quantity;
              TransLine2."Outstanding Qty. (Base)" := TransLine2."Quantity (Base)";
              TransLine2.Insert;

              TransferTracking(TransLine,TransLine2,TransLine."Qty. to Ship (Base)");

              TransLine.Validate("Quantity Shipped",TransLine."Quantity Shipped" + TransLine."Qty. to Ship");

              TransLine.UpdateWithWarehouseShipReceive;

              TransLine.Modify;
            until TransLine.Next = 0;
          end;

          if WhseShip then
            WhseShptLine.LockTable;
          LockTable;
          if WhseShip then begin
            WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
            TempWhseShptHeader.Delete;
          end;

          "Last Shipment No." := TransShptHeader."No.";
          Modify;

          TransLine.SetRange(Quantity);
          TransLine.SetRange("Qty. to Ship");
          HeaderDeleted := DeleteOneTransferOrder(TransHeader,TransLine);
          if not HeaderDeleted then begin
            WhseTransferRelease.Release(TransHeader);
            ReserveTransLine.UpdateItemTrackingAfterPosting(TransHeader,0);
            CreateReservEntry.UpdReservEntryAfterPostingPick(TransHeader);
          end;

          if not InvtPickPutaway then
            Commit;
          Clear(WhsePostShpt);
          Clear(InvtAdjmt);
          Window.Close;
        end;
        UpdateAnalysisView.UpdateAll(0,true);
        UpdateItemAnalysisView.UpdateAll(0,true);
        Rec := TransHeader;
    end;

    var
        Text001: label 'There is nothing to post.';
        Text002: label 'Warehouse handling is required for Transfer order = %1, %2 = %3.';
        Text003: label 'Posting transfer lines     #2######';
        Text004: label 'Transfer Order %1';
        Text005: label 'The combination of dimensions used in transfer order %1 is blocked. %2';
        Text006: label 'The combination of dimensions used in transfer order %1, line no. %2 is blocked. %3';
        Text007: label 'The dimensions that are used in transfer order %1, line no. %2 are not valid. %3.';
        TransShptHeader: Record "Transfer Shipment Header";
        TransShptLine: Record "Transfer Shipment Line";
        TransHeader: Record "Transfer Header";
        TransLine: Record "Transfer Line";
        TransLine2: Record "Transfer Line";
        Location: Record Location;
        ItemJnlLine: Record "Item Journal Line";
        WhseRqst: Record "Warehouse Request";
        WhseShptHeader: Record "Warehouse Shipment Header";
        TempWhseShptHeader: Record "Warehouse Shipment Header" temporary;
        WhseShptLine: Record "Warehouse Shipment Line";
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        TempWhseSplitSpecification: Record "Tracking Specification" temporary;
        TempHandlingSpecification: Record "Tracking Specification" temporary;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        WhseTransferRelease: Codeunit "Whse.-Transfer Release";
        ReserveTransLine: Codeunit "Transfer Line-Reserve";
        WhsePostShpt: Codeunit "Whse.-Post Shipment";
        InvtAdjmt: Codeunit "Inventory Adjustment";
        SourceCode: Code[10];
        HideValidationDialog: Boolean;
        HeaderDeleted: Boolean;
        WhseShip: Boolean;
        WhsePosting: Boolean;
        InvtPickPutaway: Boolean;
        WhseReference: Integer;
        OriginalQuantity: Decimal;
        OriginalQuantityBase: Decimal;
        Text008: label 'This order must be a complete shipment.';
        Text009: label 'Item %1 is not in inventory.';

    local procedure PostItemJnlLine(var TransLine3: Record "Transfer Line";TransShptHeader2: Record "Transfer Shipment Header";TransShptLine2: Record "Transfer Shipment Line")
    begin
        ItemJnlLine.Init;
        ItemJnlLine."Posting Date" := TransShptHeader2."Posting Date";
        ItemJnlLine."Document Date" := TransShptHeader2."Posting Date";
        ItemJnlLine."Document No." := TransShptHeader2."No.";
        ItemJnlLine."Document Type" := ItemJnlLine."document type"::"Transfer Shipment";
        ItemJnlLine."Document Line No." := TransShptLine2."Line No.";
        ItemJnlLine."Order Type" := ItemJnlLine."order type"::Transfer;
        ItemJnlLine."Order No." := TransShptHeader2."Transfer Order No.";
        ItemJnlLine."Order Line No." := TransLine3."Line No.";
        ItemJnlLine."External Document No." := TransShptHeader2."External Document No.";
        ItemJnlLine."Entry Type" := ItemJnlLine."entry type"::Transfer;
        ItemJnlLine."Item No." := TransShptLine2."Item No.";
        ItemJnlLine.Description := TransShptLine2.Description;
        ItemJnlLine."Shortcut Dimension 1 Code" := TransShptLine2."Shortcut Dimension 1 Code";
        ItemJnlLine."New Shortcut Dimension 1 Code" := TransShptLine2."Shortcut Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := TransShptLine2."Shortcut Dimension 2 Code";
        ItemJnlLine."New Shortcut Dimension 2 Code" := TransShptLine2."Shortcut Dimension 2 Code";
        ItemJnlLine."Dimension Set ID" := TransShptLine2."Dimension Set ID";
        ItemJnlLine."New Dimension Set ID" := TransShptLine2."Dimension Set ID";
        ItemJnlLine."Location Code" := TransShptHeader2."Transfer-from Code";
        ItemJnlLine."New Location Code" := TransHeader."In-Transit Code";
        ItemJnlLine.Quantity := TransShptLine2.Quantity;
        ItemJnlLine."Invoiced Quantity" := TransShptLine2.Quantity;
        ItemJnlLine."Quantity (Base)" := TransShptLine2."Quantity (Base)";
        ItemJnlLine."Invoiced Qty. (Base)" := TransShptLine2."Quantity (Base)";
        ItemJnlLine."Source Code" := SourceCode;
        ItemJnlLine."Gen. Prod. Posting Group" := TransShptLine2."Gen. Prod. Posting Group";
        ItemJnlLine."Inventory Posting Group" := TransShptLine2."Inventory Posting Group";
        ItemJnlLine."Unit of Measure Code" := TransShptLine2."Unit of Measure Code";
        ItemJnlLine."Qty. per Unit of Measure" := TransShptLine2."Qty. per Unit of Measure";
        ItemJnlLine."Variant Code" := TransShptLine2."Variant Code";
        ItemJnlLine."Bin Code" := TransLine."Transfer-from Bin Code";
        ItemJnlLine."Country/Region Code" := TransShptHeader2."Trsf.-from Country/Region Code";
        ItemJnlLine."Transaction Type" := TransShptHeader2."Transaction Type";
        ItemJnlLine."Transport Method" := TransShptHeader2."Transport Method";
        ItemJnlLine."Entry/Exit Point" := TransShptHeader2."Entry/Exit Point";
        ItemJnlLine.Area := TransShptHeader2.Area;
        ItemJnlLine."Transaction Specification" := TransShptHeader2."Transaction Specification";
        ItemJnlLine."Product Group Code" := TransLine."Product Group Code";
        ItemJnlLine."Item Category Code" := TransLine."Item Category Code";
        ItemJnlLine."Applies-to Entry" := TransLine."Appl.-to Item Entry";

        ReserveTransLine.TransferTransferToItemJnlLine(TransLine3,
          ItemJnlLine,ItemJnlLine."Quantity (Base)",0);

        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
    end;

    local procedure CopyCommentLines(FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
    var
        InvtCommentLine: Record "Inventory Comment Line";
        InvtCommentLine2: Record "Inventory Comment Line";
    begin
        InvtCommentLine.SetRange("Document Type",FromDocumentType);
        InvtCommentLine.SetRange("No.",FromNumber);
        if InvtCommentLine.Find('-') then
          repeat
            InvtCommentLine2 := InvtCommentLine;
            InvtCommentLine2."Document Type" := ToDocumentType;
            InvtCommentLine2."No." := ToNumber;
            InvtCommentLine2.Insert;
          until InvtCommentLine.Next = 0;
    end;

    local procedure CheckDim()
    begin
        TransLine."Line No." := 0;
        CheckDimComb(TransHeader,TransLine);
        CheckDimValuePosting(TransHeader,TransLine);

        TransLine.SetRange("Document No.",TransHeader."No.");
        if TransLine.FindFirst then begin
          CheckDimComb(TransHeader,TransLine);
          CheckDimValuePosting(TransHeader,TransLine);
        end;
    end;

    local procedure CheckDimComb(TransferHeader: Record "Transfer Header";TransferLine: Record "Transfer Line")
    begin
        if TransferLine."Line No." = 0 then
          if not DimMgt.CheckDimIDComb(TransferHeader."Dimension Set ID") then
            Error(
              Text005,
              TransHeader."No.",DimMgt.GetDimCombErr);
        if TransferLine."Line No." <> 0 then
          if not DimMgt.CheckDimIDComb(TransferLine."Dimension Set ID") then
            Error(
              Text006,
              TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(TransferHeader: Record "Transfer Header";TransferLine: Record "Transfer Line")
    var
        TableIDArr: array [10] of Integer;
        NumberArr: array [10] of Code[20];
    begin
        TableIDArr[1] := Database::Item;
        NumberArr[1] := TransferLine."Item No.";
        if TransferLine."Line No." = 0 then
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,TransferHeader."Dimension Set ID") then
            Error(Text007,TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimValuePostingErr);

        if TransferLine."Line No." <> 0 then
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,TransferLine."Dimension Set ID") then
            Error(Text007,TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimValuePostingErr);
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local procedure AssignLineNo(FromDocNo: Code[20]): Integer
    var
        TransLine3: Record "Transfer Line";
    begin
        TransLine3.SetRange("Document No.",FromDocNo);
        if TransLine3.FindLast then
          exit(TransLine3."Line No." + 10000);
    end;

    local procedure InsertShptEntryRelation(var TransShptLine: Record "Transfer Shipment Line"): Integer
    var
        TempHandlingSpecification2: Record "Tracking Specification" temporary;
        ItemEntryRelation: Record "Item Entry Relation";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        WhseSNRequired: Boolean;
        WhseLNRequired: Boolean;
    begin
        if WhsePosting then begin
          TempWhseSplitSpecification.Reset;
          TempWhseSplitSpecification.DeleteAll;
        end;

        TempHandlingSpecification2.Reset;
        if ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) then begin
          TempHandlingSpecification2.SetRange("Buffer Status",0);
          if TempHandlingSpecification2.Find('-') then begin
            repeat
              if WhsePosting or WhseShip or InvtPickPutaway then begin
                ItemTrackingMgt.CheckWhseItemTrkgSetup(
                  TransShptLine."Item No.",WhseSNRequired,WhseLNRequired,false);
                if WhseSNRequired or WhseLNRequired then begin
                  TempWhseSplitSpecification := TempHandlingSpecification2;
                  TempWhseSplitSpecification."Source Type" := Database::"Transfer Line";
                  TempWhseSplitSpecification."Source ID" := TransLine."Document No.";
                  TempWhseSplitSpecification."Source Ref. No." := TransLine."Line No.";
                  TempWhseSplitSpecification.Insert;
                end;
              end;

              ItemEntryRelation.Init;
              ItemEntryRelation."Item Entry No." := TempHandlingSpecification2."Entry No.";
              ItemEntryRelation."Serial No." := TempHandlingSpecification2."Serial No.";
              ItemEntryRelation."Lot No." := TempHandlingSpecification2."Lot No.";
              ItemEntryRelation.TransferFieldsTransShptLine(TransShptLine);
              ItemEntryRelation.Insert;
              TempHandlingSpecification := TempHandlingSpecification2;
              TempHandlingSpecification."Source Prod. Order Line" := TransShptLine."Line No.";
              TempHandlingSpecification."Buffer Status" := TempHandlingSpecification."buffer status"::Modify;
              TempHandlingSpecification.Insert;
            until TempHandlingSpecification2.Next = 0;
            exit(0);
          end;
        end else
          exit(ItemJnlLine."Item Shpt. Entry No.");
    end;

    local procedure TransferTracking(var FromTransLine: Record "Transfer Line";var ToTransLine: Record "Transfer Line";TransferQty: Decimal)
    var
        DummySpecification: Record "Tracking Specification";
    begin
        TempHandlingSpecification.Reset;
        TempHandlingSpecification.SetRange("Source Prod. Order Line",ToTransLine."Derived From Line No.");
        if TempHandlingSpecification.Find('-') then begin
          repeat
            ReserveTransLine.TransferTransferToTransfer(
              FromTransLine,ToTransLine,-TempHandlingSpecification."Quantity (Base)",1,TempHandlingSpecification);
            TransferQty += TempHandlingSpecification."Quantity (Base)";
          until TempHandlingSpecification.Next = 0;
          TempHandlingSpecification.DeleteAll;
        end;

        if TransferQty > 0 then
          ReserveTransLine.TransferTransferToTransfer(
            FromTransLine,ToTransLine,TransferQty,1,DummySpecification);
    end;

    local procedure CheckWarehouse(TransLine: Record "Transfer Line")
    var
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        ShowError: Boolean;
    begin
        GetLocation(TransLine."Transfer-from Code");
        if Location."Require Pick" or Location."Require Shipment" then begin
          if Location."Bin Mandatory" then
            ShowError := true
          else
            if WhseValidateSourceLine.WhseLinesExist(
                 Database::"Transfer Line",
                 0,// Out
                 TransLine."Document No.",
                 TransLine."Line No.",
                 0,
                 TransLine.Quantity)
            then
              ShowError := true;

          if ShowError then
            Error(
              Text002,
              TransLine."Document No.",
              TransLine.FieldCaption("Line No."),
              TransLine."Line No.");
        end;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Location.GetLocationSetup(LocationCode,Location)
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;

    local procedure PostWhseJnlLine(ItemJnlLine: Record "Item Journal Line";OriginalQuantity: Decimal;OriginalQuantityBase: Decimal)
    var
        WhseJnlLine: Record "Warehouse Journal Line";
        TempWhseJnlLine2: Record "Warehouse Journal Line" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        WMSMgmt: Codeunit "WMS Management";
    begin
        with ItemJnlLine do begin
          Quantity := OriginalQuantity;
          "Quantity (Base)" := OriginalQuantityBase;
          GetLocation("Location Code");
          if Location."Bin Mandatory" then
            if WMSMgmt.CreateWhseJnlLine(ItemJnlLine,1,WhseJnlLine,false) then begin
              WMSMgmt.SetTransferLine(TransLine,WhseJnlLine,0,TransShptHeader."No.");
              ItemTrackingMgt.SplitWhseJnlLine(
                WhseJnlLine,TempWhseJnlLine2,TempWhseSplitSpecification,true);
              if TempWhseJnlLine2.Find('-') then
                repeat
                  WMSMgmt.CheckWhseJnlLine(TempWhseJnlLine2,1,0,true);
                  Codeunit.Run(Codeunit::"Whse. Jnl.-Register Line",TempWhseJnlLine2);
                until TempWhseJnlLine2.Next = 0;
            end;
        end;
    end;


    procedure SetWhseShptHeader(var WhseShptHeader2: Record "Warehouse Shipment Header")
    begin
        WhseShptHeader := WhseShptHeader2;
        TempWhseShptHeader := WhseShptHeader;
        TempWhseShptHeader.Insert;
    end;

    local procedure GetShippingAdvice(): Boolean
    var
        TransLine: Record "Transfer Line";
    begin
        TransLine.SetRange("Document No.",TransHeader."No.");
        if TransLine.Find('-') then
          repeat
            if TransLine."Quantity (Base)" <>
               TransLine."Qty. to Ship (Base)" + TransLine."Qty. Shipped (Base)"
            then
              exit(false);
          until TransLine.Next = 0;
        exit(true);
    end;

    local procedure CheckItemInInventory(TransLine: Record "Transfer Line")
    var
        Item: Record Item;
    begin
        with Item do begin
          Get(TransLine."Item No.");
          SetFilter("Variant Filter",TransLine."Variant Code");
          SetFilter("Location Filter",TransLine."Transfer-from Code");
          CalcFields(Inventory);
          if Inventory <= 0 then
            Error(Text009,TransLine."Item No.");
        end;
    end;

    local procedure CheckItemInInventoryAndWarehouse(var TransLine: Record "Transfer Line";NeedCheckWarehouse: Boolean)
    var
        TransLine2: Record "Transfer Line";
    begin
        TransLine2.CopyFilters(TransLine);
        TransLine2.FindSet;
        repeat
          CheckItemInInventory(TransLine2);
          if  NeedCheckWarehouse then
            CheckWarehouse(TransLine2);
        until TransLine2.Next = 0;
    end;

    local procedure LockTables(AutoCostPosting: Boolean)
    var
        GLEntry: Record "G/L Entry";
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeriesLine.LockTable;
        if NoSeriesLine.FindLast then;
        if AutoCostPosting then begin
          GLEntry.LockTable;
          if GLEntry.FindLast then;
        end;
    end;
}

