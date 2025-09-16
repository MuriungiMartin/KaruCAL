#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5780 "Whse. Cross-Dock Management"
{

    trigger OnRun()
    begin
    end;

    var
        SalesLine: Record "Sales Line";
        TransLine: Record "Transfer Line";
        PurchaseLine: Record "Purchase Line";
        ProdOrderComp: Record "Prod. Order Component";
        Location: Record Location;
        WhseMgt: Codeunit "Whse. Management";
        CrossDockDate: Date;
        QtyNeededBase2: Decimal;
        QtyOnPickBase2: Decimal;
        QtyPickedBase2: Decimal;
        SourceType2: Integer;
        UseCrossDocking: Boolean;
        TemplateName: Code[10];
        NameNo: Code[20];
        LocationCode: Code[10];


    procedure GetUseCrossDock(var UseCrossDock: Boolean;LocationCode: Code[10];ItemNo: Code[20])
    var
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        Location: Record Location;
    begin
        Location.Get(LocationCode);
        Item.Get(ItemNo);
        if SKU.Get(LocationCode,ItemNo) then
          Item."Use Cross-Docking" := SKU."Use Cross-Docking";

        if Item."Use Cross-Docking" and Location."Use Cross-Docking" then
          UseCrossDock := true
        else
          UseCrossDock := false;
    end;


    procedure CalculateCrossDockLines(var WhseCrossDockOpp: Record "Whse. Cross-Dock Opportunity";NewTemplateName: Code[10];NewNameNo: Code[20];NewLocationCode: Code[10])
    var
        TempWhseRcptLineNoSpecOrder: Record "Warehouse Receipt Line" temporary;
        TempWhseRcptLineWthSpecOrder: Record "Warehouse Receipt Line" temporary;
        TempItemVariant: Record "Item Variant" temporary;
    begin
        SetTemplate(NewTemplateName,NewNameNo,NewLocationCode);
        if TemplateName <> '' then
          exit;

        SeparateWhseRcptLinesWthSpecOrder(TempWhseRcptLineNoSpecOrder,TempWhseRcptLineWthSpecOrder,TempItemVariant);
        FilterCrossDockOpp(WhseCrossDockOpp);
        CalcCrossDockWithoutSpecOrder(WhseCrossDockOpp,TempWhseRcptLineNoSpecOrder,TempItemVariant);
        CalcCrossDockForSpecialOrder(WhseCrossDockOpp,TempWhseRcptLineWthSpecOrder);
    end;

    local procedure CalcCrossDockForSpecialOrder(var WhseCrossDockOpp: Record "Whse. Cross-Dock Opportunity";var TempWhseRcptLine: Record "Warehouse Receipt Line" temporary)
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        QtyToCrossDockBase: Decimal;
        QtyOnCrossDockBase: Decimal;
        RemainingNeededQtyBase: Decimal;
        QtyOnPickBase: Decimal;
        QtyPickedBase: Decimal;
    begin
        with TempWhseRcptLine do
          if Find('-') then
            repeat
              WhseRcptLine.Get("No.","Line No.");
              WhseCrossDockOpp.SetRange("Source Line No.","Line No.");
              WhseCrossDockOpp.DeleteAll;
              GetSourceLine("Source Type","Source Subtype","Source No.","Source Line No.");
              CalculateCrossDock(
                WhseCrossDockOpp,"Item No.","Variant Code",LocationCode,
                RemainingNeededQtyBase,QtyOnPickBase,QtyPickedBase,"Line No.");

              UpdateQtyToCrossDock(
                WhseRcptLine,RemainingNeededQtyBase,QtyToCrossDockBase,QtyOnCrossDockBase);
            until Next = 0;
    end;

    local procedure CalcCrossDockWithoutSpecOrder(var WhseCrossDockOpp: Record "Whse. Cross-Dock Opportunity";var TempWhseRcptLine: Record "Warehouse Receipt Line" temporary;var TempItemVariant: Record "Item Variant" temporary)
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        QtyToCrossDockBase: Decimal;
        QtyOnCrossDockBase: Decimal;
        RemainingNeededQtyBase: Decimal;
        QtyOnPickBase: Decimal;
        QtyPickedBase: Decimal;
        NewItemVariant: Boolean;
    begin
        if TempItemVariant.FindSet then begin
          FilterWhseRcptLine(TempWhseRcptLine);
          repeat
            NewItemVariant := true;
            with TempWhseRcptLine do begin
              SetRange("Item No.",TempItemVariant."Item No.");
              SetRange("Variant Code",TempItemVariant.Code);
              if Find('-') then
                repeat
                  WhseRcptLine.Get("No.","Line No.");
                  WhseCrossDockOpp.SetRange("Source Line No.","Line No.");
                  WhseCrossDockOpp.DeleteAll;
                  if NewItemVariant then begin
                    GetSourceLine("Source Type","Source Subtype","Source No.","Source Line No.");
                    CalculateCrossDock(
                      WhseCrossDockOpp,"Item No.","Variant Code",LocationCode,
                      RemainingNeededQtyBase,QtyOnPickBase,QtyPickedBase,"Line No.");
                  end;
                  if NewItemVariant or (RemainingNeededQtyBase <> 0) then
                    UpdateQtyToCrossDock(
                      WhseRcptLine,RemainingNeededQtyBase,QtyToCrossDockBase,QtyOnCrossDockBase);

                  NewItemVariant := false;
                until (Next = 0) or (RemainingNeededQtyBase = 0);
            end;
          until TempItemVariant.Next = 0;
        end;
    end;

    local procedure CalcRemainingNeededQtyBase(ItemNo: Code[20];VariantCode: Code[10];QtyNeededBase: Decimal;var QtyToCrossDockBase: Decimal;var QtyOnCrossDockBase: Decimal;QtyToHandleBase: Decimal) RemainingNeededQtyBase: Decimal
    var
        Dummy: Decimal;
    begin
        CalcCrossDockedItems(ItemNo,VariantCode,'',LocationCode,Dummy,QtyOnCrossDockBase);
        QtyOnCrossDockBase += CalcCrossDockReceivedNotPutAway(LocationCode,ItemNo,VariantCode);

        QtyToCrossDockBase := QtyNeededBase - QtyOnCrossDockBase;
        if QtyToHandleBase < QtyToCrossDockBase then begin
          RemainingNeededQtyBase := QtyToCrossDockBase - QtyToHandleBase;
          QtyToCrossDockBase := QtyToHandleBase
        end else
          RemainingNeededQtyBase := 0;
        if QtyToCrossDockBase < 0 then
          QtyToCrossDockBase := 0;
    end;


    procedure CalculateCrossDockLine(var CrossDockOpp: Record "Whse. Cross-Dock Opportunity";ItemNo: Code[20];VariantCode: Code[10];var QtyNeededBase: Decimal;var QtyToCrossDockBase: Decimal;var QtyOnCrossDockBase: Decimal;LineNo: Integer;QtyToHandleBase: Decimal)
    var
        QtyOnPickBase: Decimal;
        QtyPickedBase: Decimal;
        Dummy: Decimal;
    begin
        FilterCrossDockOpp(CrossDockOpp);
        CrossDockOpp.SetRange("Source Line No.",LineNo);
        CrossDockOpp.DeleteAll;

        CalculateCrossDock(
          CrossDockOpp,ItemNo,VariantCode,LocationCode,QtyNeededBase,QtyOnPickBase,QtyPickedBase,LineNo);

        CalcCrossDockedItems(ItemNo,VariantCode,'',LocationCode,Dummy,QtyOnCrossDockBase);
        QtyOnCrossDockBase += CalcCrossDockReceivedNotPutAway(LocationCode,ItemNo,VariantCode);

        QtyToCrossDockBase := QtyNeededBase - QtyOnCrossDockBase;
        if QtyToHandleBase < QtyToCrossDockBase then
          QtyToCrossDockBase := QtyToHandleBase;
        if QtyToCrossDockBase < 0 then
          QtyToCrossDockBase := 0;
    end;

    local procedure CalculateCrossDock(var CrossDockOpp: Record "Whse. Cross-Dock Opportunity";ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];var QtyNeededSumBase: Decimal;var QtyOnPickSumBase: Decimal;var QtyPickedSumBase: Decimal;LineNo: Integer)
    var
        WhseRequest: Record "Warehouse Request";
        QtyOnPick: Decimal;
        QtyOnPickBase: Decimal;
        QtyPicked: Decimal;
        QtyPickedBase: Decimal;
    begin
        // Init
        QtyNeededBase2 := 0;
        QtyOnPickBase2 := 0;
        QtyPickedBase2 := 0;
        Location.Get(LocationCode);
        if Format(Location."Cross-Dock Due Date Calc.") <> '' then
          CrossDockDate := CalcDate(Location."Cross-Dock Due Date Calc.",WorkDate)
        else
          CrossDockDate := WorkDate;

        // SalesLine
        SalesLine.Reset;
        SalesLine.SetCurrentkey(
          "Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code");
        SalesLine.SetRange("Document Type",SalesLine."document type"::Order);
        SalesLine.SetRange(Type,SalesLine.Type::Item);
        SalesLine.SetRange("No.",ItemNo);
        SalesLine.SetRange("Variant Code",VariantCode);
        SalesLine.SetRange("Drop Shipment",false);
        SalesLine.SetRange("Location Code",LocationCode);
        SalesLine.SetRange("Shipment Date",0D,CrossDockDate);
        SalesLine.SetFilter("Outstanding Quantity",'>0');
        if HasSpecialOrder then begin
          SalesLine.SetRange("Document No.",PurchaseLine."Special Order Sales No.");
          SalesLine.SetRange("Line No.",PurchaseLine."Special Order Sales Line No.");
        end else
          SalesLine.SetRange("Special Order",false);
        if SalesLine.Find('-') then
          repeat
            if WhseRequest.Get(1,SalesLine."Location Code",37,
                 SalesLine."Document Type",SalesLine."Document No.") and
               (WhseRequest."Document Status" = 1)
            then
              if SalesLine."Outstanding Qty. (Base)" > 0 then begin
                CalculatePickQty(
                  37,SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.",
                  QtyOnPick,QtyOnPickBase,QtyPicked,QtyPickedBase,SalesLine.Quantity,SalesLine."Quantity (Base)",
                  SalesLine."Outstanding Quantity",SalesLine."Outstanding Qty. (Base)");
                InsertCrossDockLine(CrossDockOpp,
                  37,
                  SalesLine."Document Type",
                  SalesLine."Document No.",
                  SalesLine."Line No.",
                  0,
                  SalesLine.Quantity,
                  SalesLine."Quantity (Base)",
                  QtyOnPick,QtyOnPickBase,QtyPicked,QtyPickedBase,
                  SalesLine."Unit of Measure Code",
                  SalesLine."Qty. per Unit of Measure",
                  SalesLine."Shipment Date",
                  SalesLine."No.",
                  SalesLine."Variant Code",
                  LineNo);
              end;
          until SalesLine.Next = 0;

        // Transfer Line
        TransLine.Reset;
        TransLine.SetCurrentkey(
          "Transfer-from Code",Status,"Derived From Line No.",
          "Item No.","Variant Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
          "Shipment Date","In-Transit Code");
        TransLine.SetRange("Transfer-from Code",LocationCode);
        TransLine.SetRange(Status,TransLine.Status::Released);
        TransLine.SetRange("Derived From Line No.",0);
        TransLine.SetRange("Item No.",ItemNo);
        TransLine.SetRange("Variant Code",VariantCode);
        TransLine.SetRange("Shipment Date",0D,CrossDockDate);
        TransLine.SetFilter("Outstanding Qty. (Base)",'>0');
        if TransLine.Find('-') then
          repeat
            if WhseRequest.Get(1,TransLine."Transfer-from Code",5741,
                 0,TransLine."Document No.") and
               (WhseRequest."Document Status" = 1)
            then begin
              CalculatePickQty(
                5741,0,TransLine."Document No.",TransLine."Line No.",
                QtyOnPick,QtyOnPickBase,QtyPicked,QtyPickedBase,TransLine.Quantity,TransLine."Quantity (Base)",
                TransLine."Outstanding Quantity",TransLine."Outstanding Qty. (Base)");
              if TransLine."Outstanding Qty. (Base)" > 0 then
                InsertCrossDockLine(CrossDockOpp,
                  5741,
                  0,
                  TransLine."Document No.",
                  TransLine."Line No.",
                  0,
                  TransLine.Quantity,
                  TransLine."Quantity (Base)",
                  QtyOnPick,QtyOnPickBase,QtyPicked,QtyPickedBase,
                  TransLine."Unit of Measure Code",
                  TransLine."Qty. per Unit of Measure",
                  TransLine."Shipment Date",
                  TransLine."Item No.",
                  TransLine."Variant Code",
                  LineNo);
            end;
          until TransLine.Next = 0;

        // Production Line
        ProdOrderComp.Reset;
        ProdOrderComp.SetCurrentkey(Status,"Item No.","Variant Code","Location Code","Due Date");
        ProdOrderComp.SetRange(Status,ProdOrderComp.Status::Released);
        ProdOrderComp.SetRange("Item No.",ItemNo);
        ProdOrderComp.SetRange("Variant Code",VariantCode);
        ProdOrderComp.SetRange("Location Code",LocationCode);
        ProdOrderComp.SetRange("Due Date",0D,CrossDockDate);
        ProdOrderComp.SetRange("Flushing Method",ProdOrderComp."flushing method"::Manual);
        ProdOrderComp.SetRange("Planning Level Code",0);
        ProdOrderComp.SetFilter("Remaining Qty. (Base)",'>0');
        if ProdOrderComp.Find('-') then
          repeat
            if ProdOrderComp."Remaining Qty. (Base)" > 0 then begin
              ProdOrderComp.CalcFields("Pick Qty. (Base)");
              InsertCrossDockLine(CrossDockOpp,
                5407,
                ProdOrderComp.Status,
                ProdOrderComp."Prod. Order No.",
                ProdOrderComp."Line No.",
                ProdOrderComp."Prod. Order Line No.",
                ProdOrderComp."Remaining Quantity",
                ProdOrderComp."Remaining Qty. (Base)",
                ProdOrderComp."Pick Qty.",
                ProdOrderComp."Pick Qty. (Base)",
                ProdOrderComp."Qty. Picked",
                ProdOrderComp."Qty. Picked (Base)",
                ProdOrderComp."Unit of Measure Code",
                ProdOrderComp."Qty. per Unit of Measure",
                ProdOrderComp."Due Date",
                ProdOrderComp."Item No.",
                ProdOrderComp."Variant Code",
                LineNo);
            end;
          until ProdOrderComp.Next = 0;

        // Post code
        QtyNeededSumBase := QtyNeededBase2;
        QtyOnPickSumBase := QtyOnPickBase2;
        QtyPickedSumBase := QtyPickedBase2;
    end;

    local procedure InsertCrossDockLine(var CrossDockOpp: Record "Whse. Cross-Dock Opportunity";SourceType: Integer;SourceSubType: Integer;SourceNo: Code[20];SourceLineNo: Integer;SourceSubLineNo: Integer;QtyOutstanding: Decimal;QtyOutstandingBase: Decimal;QtyOnPick: Decimal;QtyOnPickBase: Decimal;QtyPicked: Decimal;QtyPickedBase: Decimal;UOMCode: Code[10];QtyPerUOM: Decimal;DueDate: Date;ItemNo: Code[20];VariantCode: Code[10];LineNo: Integer)
    begin
        if HasSpecialOrder and (SourceType <> Database::"Sales Line") then
          exit;
        if (QtyOutstandingBase - QtyOnPickBase - QtyPickedBase) <= 0 then
          exit;

        with CrossDockOpp do begin
          Init;
          "Source Template Name" := TemplateName;
          "Source Name/No." := NameNo;
          "Source Line No." := LineNo;
          "Line No." := "Line No." + 10000;
          "To Source Type" := SourceType;
          "To Source Subtype" := SourceSubType;
          "To Source No." := SourceNo;
          "To Source Line No." := SourceLineNo;
          "To Source Subline No." := SourceSubLineNo;
          "To Source Document" := WhseMgt.GetSourceDocument("To Source Type","To Source Subtype");
          "Due Date" := DueDate;
          "To-Src. Unit of Measure Code" := UOMCode;
          "To-Src. Qty. per Unit of Meas." := QtyPerUOM;
          "Item No." := ItemNo;
          "Variant Code" := VariantCode;
          "Location Code" := LocationCode;

          SubtractExistingCrossDockOppQtysToSource(CrossDockOpp);

          "Qty. Needed (Base)" := Maximum("Qty. Needed (Base)" + QtyOutstandingBase - QtyOnPickBase - QtyPickedBase,0);
          "Qty. Needed" := Maximum("Qty. Needed" + QtyOutstanding - QtyOnPick - QtyPicked,0);

          "Pick Qty. (Base)" := Maximum("Pick Qty. (Base)" + QtyOnPickBase,0);
          "Pick Qty." := Maximum("Pick Qty." + QtyOnPick,0);

          "Picked Qty. (Base)" := Maximum("Picked Qty. (Base)" + QtyPickedBase,0);
          "Picked Qty." := Maximum("Picked Qty." + QtyPicked,0);

          Insert;
          QtyNeededBase2 += "Qty. Needed (Base)";
          QtyOnPickBase2 += "Pick Qty. (Base)";
          QtyPickedBase2 += "Picked Qty. (Base)";
        end;
    end;


    procedure ShowCrossDock(var CrossDockOpp: Record "Whse. Cross-Dock Opportunity";SourceTemplateName: Code[10];SourceNameNo: Code[20];SourceLineNo: Integer;LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10])
    var
        ReceiptLine: Record "Warehouse Receipt Line";
        CrossDockForm: Page "Cross-Dock Opportunities";
        QtyToCrossDock: Decimal;
    begin
        with CrossDockOpp do begin
          FilterGroup(2);
          SetRange("Source Template Name",SourceTemplateName);
          SetRange("Source Name/No.",SourceNameNo);
          SetRange("Location Code",LocationCode);
          SetRange("Source Line No.",SourceLineNo);
          FilterGroup(0);
        end;
        ReceiptLine.Get(SourceNameNo,SourceLineNo);
        CrossDockForm.SetValues(ItemNo,VariantCode,LocationCode,SourceTemplateName,SourceNameNo,SourceLineNo,
          ReceiptLine."Unit of Measure Code",ReceiptLine."Qty. per Unit of Measure");
        CrossDockForm.LookupMode(true);
        CrossDockForm.SetTableview(CrossDockOpp);
        if CrossDockForm.RunModal = Action::LookupOK then begin
          CrossDockForm.GetValues(QtyToCrossDock);
          QtyToCrossDock := QtyToCrossDock / ReceiptLine."Qty. per Unit of Measure";
          if ReceiptLine."Qty. to Receive" < QtyToCrossDock then
            QtyToCrossDock := ReceiptLine."Qty. to Receive";
          ReceiptLine.Validate("Qty. to Cross-Dock",QtyToCrossDock);
          ReceiptLine.Modify;
        end;
    end;


    procedure CalcCrossDockedItems(ItemNo: Code[20];VariantCode: Code[10];UOMCode: Code[10];LocationCode: Code[10];var QtyCrossDockedUOMBase: Decimal;var QtyCrossDockedAllUOMBase: Decimal)
    var
        BinContent: Record "Bin Content";
        QtyAvailToPickBase: Decimal;
    begin
        QtyCrossDockedUOMBase := 0;
        QtyCrossDockedAllUOMBase := 0;
        with BinContent do begin
          Reset;
          SetRange("Location Code",LocationCode);
          SetRange("Item No.",ItemNo);
          SetRange("Variant Code",VariantCode);
          SetRange("Cross-Dock Bin",true);
          if Find('-') then
            repeat
              QtyAvailToPickBase := CalcQtyAvailToPick(0);
              if "Unit of Measure Code" = UOMCode then
                QtyCrossDockedUOMBase := QtyCrossDockedUOMBase + QtyAvailToPickBase;
              QtyCrossDockedAllUOMBase := QtyCrossDockedAllUOMBase + QtyAvailToPickBase;
            until Next = 0;
        end;
    end;


    procedure CalcCrossDockReceivedNotPutAway(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10]): Decimal
    var
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
    begin
        with PostedWhseReceiptLine do begin
          SetRange("Location Code",LocationCode);
          SetRange("Item No.",ItemNo);
          SetRange("Variant Code",VariantCode);
          SetRange("Qty. Put Away (Base)",0);
          CalcSums("Qty. Cross-Docked (Base)");
          exit("Qty. Cross-Docked (Base)");
        end;
    end;


    procedure ShowBinContentsCrossDocked(ItemNo: Code[20];VariantCode: Code[10];UOMCode: Code[10];LocationCode: Code[10];FilterOnUOM: Boolean)
    var
        BinContent: Record "Bin Content";
        BinContentLookup: Page "Bin Contents List";
    begin
        with BinContent do begin
          SetRange("Item No.",ItemNo);
          SetRange("Variant Code",VariantCode);
          SetRange("Cross-Dock Bin",true);
          if FilterOnUOM then
            SetRange("Unit of Measure Code",UOMCode);
        end;
        with BinContentLookup do begin
          SetTableview(BinContent);
          Initialize(LocationCode);
          RunModal;
        end;
        Clear(BinContentLookup);
    end;

    local procedure GetSourceLine(SourceType: Option;SourceSubtype: Option;SourceNo: Code[20];SourceLineNo: Integer)
    begin
        if SourceType = Database::"Purchase Line" then begin
          PurchaseLine.Get(SourceSubtype,SourceNo,SourceLineNo);
          SourceType2 := SourceType;
        end;
    end;

    local procedure CalculatePickQty(SourceType: Integer;SourceSubtype: Integer;SourceNo: Code[20];SourceLineNo: Integer;var QtyOnPick: Decimal;var QtyOnPickBase: Decimal;var QtyPicked: Decimal;var QtyPickedBase: Decimal;Qty: Decimal;QtyBase: Decimal;OutstandingQty: Decimal;OutstandingQtyBase: Decimal)
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        QtyOnPickBase := 0;
        QtyPickedBase := 0;
        with WhseShptLine do begin
          Reset;
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceNo);
          SetRange("Source Line No.",SourceLineNo);
          if Find('-') then
            repeat
              CalcFields("Pick Qty. (Base)","Pick Qty.");
              QtyOnPick := QtyOnPick + "Pick Qty.";
              QtyOnPickBase := QtyOnPickBase + "Pick Qty. (Base)";
              QtyPicked := QtyPicked + "Qty. Picked";
              QtyPickedBase := QtyPickedBase + "Qty. Picked (Base)";
            until Next = 0;
          if QtyPickedBase = 0 then begin
            QtyPicked := Qty - OutstandingQty;
            QtyPickedBase := QtyBase - OutstandingQtyBase;
          end;
        end;
    end;


    procedure SetTemplate(NewTemplateName: Code[10];NewNameNo: Code[20];NewLocationCode: Code[10])
    begin
        TemplateName := NewTemplateName;
        NameNo := NewNameNo;
        LocationCode := NewLocationCode;
    end;

    local procedure SeparateWhseRcptLinesWthSpecOrder(var TempWhseRcptLineNoSpecOrder: Record "Warehouse Receipt Line" temporary;var TempWhseRcptLineWthSpecOrder: Record "Warehouse Receipt Line" temporary;var TempItemVariant: Record "Item Variant" temporary)
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        FilterWhseRcptLine(WhseRcptLine);
        with WhseRcptLine do
          if FindSet then
            repeat
              GetSourceLine("Source Type","Source Subtype","Source No.","Source Line No.");
              if HasSpecialOrder then begin
                TempWhseRcptLineWthSpecOrder := WhseRcptLine;
                TempWhseRcptLineWthSpecOrder.Insert;
              end else begin
                TempWhseRcptLineNoSpecOrder := WhseRcptLine;
                TempWhseRcptLineNoSpecOrder.Insert;
                InsertToItemList(WhseRcptLine,TempItemVariant);
              end;
            until Next = 0;
    end;

    local procedure InsertToItemList(WhseRcptLine: Record "Warehouse Receipt Line";var TempItemVariant: Record "Item Variant" temporary)
    begin
        with TempItemVariant do begin
          Init;
          "Item No." := WhseRcptLine."Item No.";
          Code := WhseRcptLine."Variant Code";
          if Insert then;
        end;
    end;

    local procedure FilterWhseRcptLine(var WhseRcptLine: Record "Warehouse Receipt Line")
    begin
        with WhseRcptLine do begin
          SetRange("No.",NameNo);
          SetRange("Location Code",LocationCode);
          SetFilter("Qty. to Receive",'>0');
        end;
    end;

    local procedure FilterCrossDockOpp(var WhseCrossDockOpp: Record "Whse. Cross-Dock Opportunity")
    begin
        with WhseCrossDockOpp do begin
          SetRange("Source Template Name",TemplateName);
          SetRange("Source Name/No.",NameNo);
          SetRange("Location Code",LocationCode);
        end;
    end;

    local procedure UpdateQtyToCrossDock(var WhseRcptLine: Record "Warehouse Receipt Line";var RemainingNeededQtyBase: Decimal;var QtyToCrossDockBase: Decimal;var QtyOnCrossDockBase: Decimal)
    begin
        with WhseRcptLine do begin
          GetUseCrossDock(UseCrossDocking,"Location Code","Item No.");
          if not UseCrossDocking then
            exit;

          RemainingNeededQtyBase :=
            CalcRemainingNeededQtyBase(
              "Item No.","Variant Code",RemainingNeededQtyBase,
              QtyToCrossDockBase,QtyOnCrossDockBase,"Qty. to Receive (Base)");
          Validate("Qty. to Cross-Dock",ROUND(QtyToCrossDockBase / "Qty. per Unit of Measure",0.00001));
          "Qty. to Cross-Dock (Base)" := QtyToCrossDockBase;
          Modify;
        end;
    end;

    local procedure HasSpecialOrder(): Boolean
    begin
        exit((SourceType2 = Database::"Purchase Line") and PurchaseLine."Special Order");
    end;

    local procedure SubtractExistingCrossDockOppQtysToSource(var WhseCrossDockOpp: Record "Whse. Cross-Dock Opportunity")
    var
        ExistingWhseCrossDockOpp: Record "Whse. Cross-Dock Opportunity";
    begin
        with ExistingWhseCrossDockOpp do begin
          SetRange("To Source Type",WhseCrossDockOpp."To Source Type");
          SetRange("To Source Subtype",WhseCrossDockOpp."To Source Subtype");
          SetRange("To Source No.",WhseCrossDockOpp."To Source No.");
          SetRange("To Source Line No.",WhseCrossDockOpp."To Source Line No.");
          SetRange("To Source Subline No.",WhseCrossDockOpp."To Source Subline No.");
          SetRange("Item No.",WhseCrossDockOpp."Item No.");
          SetRange("Variant Code",WhseCrossDockOpp."Variant Code");
          CalcSums("Qty. to Cross-Dock (Base)","Pick Qty. (Base)","Picked Qty. (Base)");

          WhseCrossDockOpp."Qty. Needed" :=
            -ROUND("Qty. to Cross-Dock (Base)" / WhseCrossDockOpp."To-Src. Qty. per Unit of Meas.",0.00001);
          WhseCrossDockOpp."Qty. Needed (Base)" := -"Qty. to Cross-Dock (Base)";
          WhseCrossDockOpp."Pick Qty." :=
            -ROUND("Pick Qty. (Base)" / WhseCrossDockOpp."To-Src. Qty. per Unit of Meas.",0.00001);
          WhseCrossDockOpp."Pick Qty. (Base)" := -"Pick Qty. (Base)";
          WhseCrossDockOpp."Picked Qty." :=
            -ROUND("Picked Qty. (Base)" / WhseCrossDockOpp."To-Src. Qty. per Unit of Meas.",0.00001);
          WhseCrossDockOpp."Picked Qty. (Base)" := -"Picked Qty. (Base)";
        end;
    end;

    local procedure Maximum(Value1: Decimal;Value2: Decimal): Decimal
    begin
        if Value1 >= Value2 then
          exit(Value1);
        exit(Value2);
    end;
}

