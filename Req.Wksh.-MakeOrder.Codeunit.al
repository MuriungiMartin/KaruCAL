#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 333 "Req. Wksh.-Make Order"
{
    Permissions = TableData "Sales Line"=m;
    TableNo = "Requisition Line";

    trigger OnRun()
    begin
        if PlanningResiliency then
          LockTable;
        CarryOutReqLineAction(Rec);
    end;

    var
        Text000: label 'Worksheet Name                     #1##########\\';
        Text001: label 'Checking worksheet lines           #2######\';
        Text002: label 'Creating purchase orders           #3######\';
        Text003: label 'Creating purchase lines            #4######\';
        Text004: label 'Updating worksheet lines           #5######';
        Text005: label 'Deleting worksheet lines           #5######';
        Text006: label '%1 on sales order %2 is already associated with purchase order %3.';
        Text007: label '<Month Text>';
        Text008: label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text009: label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
        ReservEntry: Record "Reservation Entry";
        PurchSetup: Record "Purchases & Payables Setup";
        ReqTemplate: Record "Req. Wksh. Template";
        ReqWkshName: Record "Requisition Wksh. Name";
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        TransHeader: Record "Transfer Header";
        AccountingPeriod: Record "Accounting Period";
        TempFailedReqLine: Record "Requisition Line" temporary;
        PurchasingCode: Record Purchasing;
        ReqWkshMakeOrders: Codeunit "Req. Wksh.-Make Order";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ReserveReqLine: Codeunit "Req. Line-Reserve";
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        OrderDateReq: Date;
        PostingDateReq: Date;
        ReceiveDateReq: Date;
        EndOrderDate: Date;
        PlanningResiliency: Boolean;
        PrintPurchOrders: Boolean;
        ReferenceReq: Text[35];
        MonthText: Text[30];
        OrderCounter: Integer;
        LineCount: Integer;
        OrderLineCounter: Integer;
        StartLineNo: Integer;
        NextLineNo: Integer;
        Day: Integer;
        Week: Integer;
        Month: Integer;
        CounterFailed: Integer;
        PrevPurchCode: Code[10];
        PrevShipToCode: Code[10];
        PrevLocationCode: Code[10];
        Text010: label 'must match %1 on Sales Order %2, Line %3';
        PrevChangedDocOrderType: Option;
        PrevChangedDocOrderNo: Code[20];


    procedure CarryOutBatchAction(var ReqLine2: Record "Requisition Line")
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.Copy(ReqLine2);
        ReqLine.SetRange("Accept Action Message",true);
        Code(ReqLine);
        ReqLine2 := ReqLine;
    end;


    procedure Set(NewPurchOrderHeader: Record "Purchase Header";NewEndingOrderDate: Date;NewPrintPurchOrder: Boolean)
    begin
        PurchOrderHeader := NewPurchOrderHeader;
        EndOrderDate := NewEndingOrderDate;
        PrintPurchOrders := NewPrintPurchOrder;
        OrderDateReq := PurchOrderHeader."Order Date";
        PostingDateReq := PurchOrderHeader."Posting Date";
        ReceiveDateReq := PurchOrderHeader."Expected Receipt Date";
        ReferenceReq := PurchOrderHeader."Your Reference";
    end;

    local procedure "Code"(var ReqLine: Record "Requisition Line")
    var
        ReqLine2: Record "Requisition Line";
        ReqLine3: Record "Requisition Line";
    begin
        with ReqLine do begin
          Clear(PurchOrderHeader);

          SetRange("Worksheet Template Name","Worksheet Template Name");
          SetRange("Journal Batch Name","Journal Batch Name");
          if not PlanningResiliency then
            LockTable;

          if "Planning Line Origin" <> "planning line origin"::"Order Planning" then
            ReqTemplate.Get("Worksheet Template Name");

          if ReqTemplate.Recurring then begin
            SetRange("Order Date",0D,EndOrderDate);
            SetFilter("Expiration Date",'%1 | %2..',0D,WorkDate);
          end;

          if not Find('=><') then begin
            "Line No." := 0;
            Commit;
            exit;
          end;

          if ReqTemplate.Recurring then
            Window.Open(
              Text000 +
              Text001 +
              Text002 +
              Text003 +
              Text004)
          else
            Window.Open(
              Text000 +
              Text001 +
              Text002 +
              Text003 +
              Text005);

          Window.Update(1,"Journal Batch Name");

          // Check lines
          LineCount := 0;
          StartLineNo := "Line No.";
          repeat
            LineCount := LineCount + 1;
            Window.Update(2,LineCount);
            CheckRecurringLine(ReqLine);
            CheckReqWkshLine(ReqLine);
            if Next = 0 then
              Find('-');
          until "Line No." = StartLineNo;

          // Create lines
          LineCount := 0;
          OrderCounter := 0;
          OrderLineCounter := 0;
          Clear(PurchOrderHeader);
          SetPurchOrderHeader;
          PurchSetup.Get;
          SetCurrentkey(
            "Worksheet Template Name","Journal Batch Name","Vendor No.",
            "Sell-to Customer No.","Ship-to Code","Order Address Code","Currency Code",
            "Ref. Order Type","Ref. Order Status","Ref. Order No.",
            "Location Code","Transfer-from Code");

          if Find('-') then
            repeat
              if PlanningResiliency then begin
                if not TryCarryOutReqLineAction(ReqLine) then begin
                  SetFailedReqLine(ReqLine);
                  CounterFailed := CounterFailed + 1;
                end;
              end else
                CarryOutReqLineAction(ReqLine);
            until Next = 0;

          if PrintPurchOrders then
            PrintTransOrder(TransHeader);
          if (PurchSetup."Combine Special Orders Default" <>
              PurchSetup."combine special orders default"::"Never Combine") and
             (PurchOrderHeader."Buy-from Vendor No." <> '')
          then
            FinalizeOrderHeader(PurchOrderHeader,ReqLine)
          else
            if not (PurchasingCode."Special Order" and
                    (PurchOrderHeader."Buy-from Vendor No." <> ''))
            then
              FinalizeOrderHeader(PurchOrderHeader,ReqLine);

          if PrevChangedDocOrderNo <> '' then
            PrintChangedDocument(PrevChangedDocOrderType,PrevChangedDocOrderNo);

          // Copy number of created orders and current journal batch name to requisition worksheet
          Init;
          "Line No." := OrderCounter;

          if OrderCounter <> 0 then
            if not ReqTemplate.Recurring then begin
              // Not a recurring journal
              ReqLine2.Copy(ReqLine);
              ReqLine2.SetFilter("Vendor No.",'<>%1','');
              if ReqLine2.FindFirst then; // Remember the last line
              if Find('-') then
                repeat
                  TempFailedReqLine := ReqLine;
                  if not TempFailedReqLine.Find then
                    Delete(true);
                until Next = 0;

              ReqLine3.SetRange("Worksheet Template Name","Worksheet Template Name");
              ReqLine3.SetRange("Journal Batch Name","Journal Batch Name");
              if not ReqLine3.FindLast then
                if IncStr("Journal Batch Name") <> '' then begin
                  ReqWkshName.Get("Worksheet Template Name","Journal Batch Name");
                  ReqWkshName.Delete;
                  ReqWkshName.Name := IncStr("Journal Batch Name");
                  if ReqWkshName.Insert then;
                  "Journal Batch Name" := ReqWkshName.Name;
                end;
            end;
        end;
    end;

    local procedure CheckReqWkshLine(var ReqLine2: Record "Requisition Line")
    var
        SalesLine: Record "Sales Line";
        Purchasing: Record Purchasing;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        with ReqLine2 do begin
          if ("No." <> '') or ("Vendor No." <> '') or (Quantity <> 0) then begin
            TestField("No.");
            if "Action Message" <> "action message"::Cancel then
              TestField(Quantity);
            if ("Action Message" = "action message"::" ") or
               ("Action Message" = "action message"::New)
            then
              if "Replenishment System" = "replenishment system"::Purchase then begin
                if "Planning Line Origin" = "planning line origin"::"Order Planning" then
                  TestField("Supply From");
                TestField("Vendor No.")
              end else
                if "Replenishment System" = "replenishment system"::Transfer then begin
                  TestField("Location Code");
                  if "Planning Line Origin" = "planning line origin"::"Order Planning" then
                    TestField("Supply From");
                  TestField("Transfer-from Code");
                end;
          end;

          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            Error(
              Text008,
              TableCaption,"Worksheet Template Name","Journal Batch Name","Line No.",
              DimMgt.GetDimCombErr);

          TableID[1] := DimMgt.TypeToTableID3(Type);
          No[1] := "No.";
          if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
            if "Line No." <> 0 then
              Error(
                Text009,
                TableCaption,"Worksheet Template Name","Journal Batch Name","Line No.",
                DimMgt.GetDimValuePostingErr)
            else
              Error(DimMgt.GetDimValuePostingErr);

          if SalesLine.Get(SalesLine."document type"::Order,"Sales Order No.","Sales Order Line No.") and
             (SalesLine."Unit of Measure Code" <> "Unit of Measure Code")
          then
            if SalesLine."Drop Shipment" or
               (PurchasingCode.Get("Purchasing Code") and PurchasingCode."Drop Shipment")
            then
              FieldError(
                "Unit of Measure Code",
                StrSubstNo(
                  Text010,
                  SalesLine.FieldCaption("Unit of Measure Code"),
                  SalesLine."Document No.",
                  SalesLine."Line No."));

          if Purchasing.Get("Purchasing Code") then
            if Purchasing."Drop Shipment" or Purchasing."Special Order" then begin
              SalesLine.Get(SalesLine."document type"::Order,"Sales Order No.","Sales Order Line No.");
              if (Purchasing."Drop Shipment" <> SalesLine."Drop Shipment") or
                 (Purchasing."Special Order" <> SalesLine."Special Order")
              then
                FieldError(
                  "Purchasing Code",
                  StrSubstNo(
                    Text010,
                    SalesLine.FieldCaption("Purchasing Code"),
                    SalesLine."Document No.",
                    SalesLine."Line No."));
            end;
        end;
    end;

    local procedure CarryOutReqLineAction(var ReqLine: Record "Requisition Line")
    var
        CarryOutAction: Codeunit "Carry Out Action";
    begin
        with ReqLine do
          case "Replenishment System" of
            "replenishment system"::Transfer:
              case "Action Message" of
                "action message"::Cancel:
                  begin
                    CarryOutAction.DeleteOrderLines(ReqLine);
                    OrderCounter := OrderCounter + 1;
                  end;
                "action message"::"Change Qty.","action message"::Reschedule,"action message"::"Resched. & Chg. Qty.":
                  begin
                    if (PrevChangedDocOrderNo <> '') and
                       (("Ref. Order Type" <> PrevChangedDocOrderType) or ("Ref. Order No." <> PrevChangedDocOrderNo))
                    then
                      PrintChangedDocument(PrevChangedDocOrderType,PrevChangedDocOrderNo);
                    CarryOutAction.SetPrintOrder(false);
                    CarryOutAction.TransOrderChgAndReshedule(ReqLine);
                    PrevChangedDocOrderType := "Ref. Order Type";
                    PrevChangedDocOrderNo := "Ref. Order No.";
                    OrderCounter := OrderCounter + 1;
                  end;
                "action message"::New,"action message"::" ":
                  begin
                    CarryOutAction.SetPrintOrder(PrintPurchOrders);
                    CarryOutAction.InsertTransLine(ReqLine,TransHeader);
                    OrderCounter := OrderCounter + 1;
                  end;
              end;
            "replenishment system"::Purchase,"replenishment system"::"Prod. Order":
              case "Action Message" of
                "action message"::Cancel:
                  begin
                    CarryOutAction.DeleteOrderLines(ReqLine);
                    OrderCounter := OrderCounter + 1;
                  end;
                "action message"::"Change Qty.","action message"::Reschedule, "action message"::"Resched. & Chg. Qty.":
                  begin
                    if (PrevChangedDocOrderNo <> '') and
                       (("Ref. Order Type" <> PrevChangedDocOrderType) or ("Ref. Order No." <> PrevChangedDocOrderNo))
                    then
                      PrintChangedDocument(PrevChangedDocOrderType,PrevChangedDocOrderNo);
                    CarryOutAction.SetPrintOrder(false);
                    CarryOutAction.PurchOrderChgAndReshedule(ReqLine);
                    PrevChangedDocOrderType := "Ref. Order Type";
                    PrevChangedDocOrderNo := "Ref. Order No.";
                    OrderCounter := OrderCounter + 1;
                  end;
                "action message"::New,"action message"::" ":
                  begin
                    if not PurchasingCode.Get("Purchasing Code") then
                      PurchasingCode."Special Order" := false;
                    if (PurchasingCode."Special Order" and
                        (PurchSetup."Combine Special Orders Default" =
                         PurchSetup."combine special orders default"::"Always Combine") and
                        ((PurchOrderHeader."Buy-from Vendor No." <> '') and
                         (PurchOrderHeader."Buy-from Vendor No." <> "Vendor No.") or
                         (PurchOrderHeader."Location Code" <> "Location Code") or
                         (PurchOrderHeader."Currency Code" <> "Currency Code") or
                         (PrevPurchCode <> "Purchasing Code"))) or
                       ((not PurchasingCode."Special Order") and
                        (((PurchOrderHeader."Buy-from Vendor No." <> '') and
                          ((PurchOrderHeader."Buy-from Vendor No." <> "Vendor No.") or
                           (PurchOrderHeader."Currency Code" <> "Currency Code"))) or
                         (PurchOrderHeader."Sell-to Customer No." <> "Sell-to Customer No.") or
                         (PurchOrderHeader."Ship-to Code" <> "Ship-to Code") or
                         (PurchOrderHeader."Order Address Code" <> "Order Address Code") or
                         (PrevPurchCode <> "Purchasing Code")))
                    then begin
                      FinalizeOrderHeader(PurchOrderHeader,ReqLine);
                      PurchOrderLine.Reset;
                      PurchOrderLine.SetRange("Document Type",PurchOrderHeader."Document Type");
                      PurchOrderLine.SetRange("Document No.",PurchOrderHeader."No.");
                      PurchOrderLine.SetFilter("Special Order Sales Line No.",'<> 0');
                      if PurchOrderLine.Find('-') then
                        repeat
                          SalesOrderLine.Get(SalesOrderLine."document type"::Order,PurchOrderLine."Special Order Sales No.",
                            PurchOrderLine."Special Order Sales Line No.");
                        until PurchOrderLine.Next = 0;
                    end;
                    MakeRecurringTexts(ReqLine);
                    InsertPurchOrderLine(ReqLine,PurchOrderHeader);
                  end;
              end;
          end;
    end;

    local procedure TryCarryOutReqLineAction(var ReqLine: Record "Requisition Line"): Boolean
    begin
        with ReqLine do begin
          ReqWkshMakeOrders.Set(PurchOrderHeader,EndOrderDate,PrintPurchOrders);
          ReqWkshMakeOrders.SetTryParam(
            ReqTemplate,
            LineCount,
            NextLineNo,
            PrevPurchCode,
            PrevShipToCode,
            OrderCounter,
            OrderLineCounter,
            TempFailedReqLine);
          if ReqWkshMakeOrders.Run(ReqLine) then begin
            ReqWkshMakeOrders.GetTryParam(
              PurchOrderHeader,
              LineCount,
              NextLineNo,
              PrevPurchCode,
              PrevShipToCode,
              OrderCounter,
              OrderLineCounter);

            Window.Update(3,OrderCounter);
            Window.Update(4,LineCount);
            Window.Update(5,OrderLineCounter);
            exit(true);
          end;
          exit(false)
        end;
    end;

    local procedure InsertPurchOrderLine(var ReqLine2: Record "Requisition Line";var PurchOrderHeader: Record "Purchase Header")
    var
        PurchOrderLine2: Record "Purchase Line";
        AddOnIntegrMgt: Codeunit AddOnIntegrManagement;
        CarryOutAction: Codeunit "Carry Out Action";
        DimensionSetIDArr: array [10] of Integer;
        DropShptSplOrderDiffAddress: Boolean;
    begin
        with ReqLine2 do begin
          if ("No." = '') or ("Vendor No." = '') or (Quantity = 0) then
            exit;
          DropShptSplOrderDiffAddress := CheckAddressDetails(PurchOrderHeader,"Sales Order No.");
          if not PurchasingCode.Get("Purchasing Code") then
            PurchasingCode."Special Order" := false;
          if (PurchasingCode."Special Order" and
              (PurchSetup."Combine Special Orders Default" =
               PurchSetup."combine special orders default"::"Always Combine") and
               not PurchasingParametersMatch(PurchOrderHeader,ReqLine2)) or
             (not PurchasingCode."Special Order" and
               ((PurchOrderHeader."Sell-to Customer No." <> "Sell-to Customer No.") or
               (PrevShipToCode <> "Ship-to Code") or
               (PurchOrderHeader."Order Address Code" <> "Order Address Code") or
               DropShptSplOrderDiffAddress or
               not PurchasingParametersMatch(PurchOrderHeader,ReqLine2)))
          then begin
            InsertHeader(ReqLine2);
            LineCount := 0;
            NextLineNo := 0;
            PrevPurchCode := "Purchasing Code";
            PrevShipToCode := "Ship-to Code";
            PrevLocationCode := "Location Code";
          end;
          if PurchasingCode."Special Order" and
             (PurchSetup."Combine Special Orders Default" =
              PurchSetup."combine special orders default"::"Never Combine") and
             not PurchasingParametersMatch(PurchOrderHeader,ReqLine2)
          then
            InsertHeader(ReqLine2);

          LineCount := LineCount + 1;
          if not PlanningResiliency then
            Window.Update(4,LineCount);

          TestField("Currency Code",PurchOrderHeader."Currency Code");

          PurchOrderLine.Init;
          PurchOrderLine.BlockDynamicTracking(true);
          PurchOrderLine."Document Type" := PurchOrderLine."document type"::Order;
          PurchOrderLine."Buy-from Vendor No." := "Vendor No.";
          PurchOrderLine."Document No." := PurchOrderHeader."No.";
          NextLineNo := NextLineNo + 10000;
          PurchOrderLine."Line No." := NextLineNo;
          PurchOrderLine.Validate(Type,Type);
          PurchOrderLine.Validate("No.","No.");
          PurchOrderLine."Variant Code" := "Variant Code";
          PurchOrderLine.Validate("Location Code","Location Code");
          PurchOrderLine.Validate("Unit of Measure Code","Unit of Measure Code");
          PurchOrderLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          PurchOrderLine."Prod. Order No." := "Prod. Order No.";
          PurchOrderLine."Prod. Order Line No." := "Prod. Order Line No.";
          PurchOrderLine.Validate(Quantity,Quantity);
          if PurchOrderHeader."Prices Including VAT" then
            PurchOrderLine.Validate("Direct Unit Cost","Direct Unit Cost" * (1 + PurchOrderLine."VAT %" / 100))
          else
            PurchOrderLine.Validate("Direct Unit Cost","Direct Unit Cost");

          PurchOrderLine.Validate("Line Discount %","Line Discount %");
          PurchOrderLine."Vendor Item No." := "Vendor Item No.";

          PurchOrderLine.Description := Description;
          PurchOrderLine."Description 2" := "Description 2";
          PurchOrderLine."Sales Order No." := "Sales Order No.";
          PurchOrderLine."Sales Order Line No." := "Sales Order Line No.";
          PurchOrderLine."Prod. Order No." := "Prod. Order No.";
          PurchOrderLine."Bin Code" := "Bin Code";
          PurchOrderLine."Item Category Code" := "Item Category Code";
          PurchOrderLine.Nonstock := Nonstock;
          PurchOrderLine.Validate("Planning Flexibility","Planning Flexibility");
          PurchOrderLine.Validate("Purchasing Code","Purchasing Code");
          PurchOrderLine."Product Group Code" := "Product Group Code";
          if "Due Date" <> 0D then begin
            PurchOrderLine.Validate("Expected Receipt Date","Due Date");
            PurchOrderLine."Requested Receipt Date" := PurchOrderLine."Planned Receipt Date";
          end;

          Modify;

          AddOnIntegrMgt.TransferFromReqLineToPurchLine(PurchOrderLine,ReqLine2);

          PurchOrderLine."Drop Shipment" := "Sales Order Line No." <> 0;

          if PurchasingCode.Get("Purchasing Code") then
            if PurchasingCode."Special Order" then begin
              PurchOrderLine."Special Order Sales No." := "Sales Order No.";
              PurchOrderLine."Special Order Sales Line No." := "Sales Order Line No.";
              PurchOrderLine."Special Order" := true;
              PurchOrderLine."Drop Shipment" := false;
              PurchOrderLine."Sales Order No." := '';
              PurchOrderLine."Sales Order Line No." := 0;
              PurchOrderLine."Special Order" := true;
              PurchOrderLine.UpdateUnitCost;
            end;

          ReserveReqLine.TransferReqLineToPurchLine(ReqLine2,PurchOrderLine,"Quantity (Base)",false);
          DimensionSetIDArr[1] := PurchOrderLine."Dimension Set ID";
          DimensionSetIDArr[2] := "Dimension Set ID";
          PurchOrderLine."Dimension Set ID" :=
            DimMgt.GetCombinedDimensionSetID(
              DimensionSetIDArr,PurchOrderLine."Shortcut Dimension 1 Code",PurchOrderLine."Shortcut Dimension 2 Code");
          PurchOrderLine.Insert;

          if Reserve then
            ReserveBindingOrderToPurch(PurchOrderLine,ReqLine2);

          if PurchOrderLine."Drop Shipment" or PurchOrderLine."Special Order" then begin
            SalesOrderLine.LockTable;
            SalesOrderHeader.LockTable;
            SalesOrderHeader.Get(SalesOrderHeader."document type"::Order,"Sales Order No.");
            if not PurchOrderLine."Special Order" then
              TestField("Ship-to Code",SalesOrderHeader."Ship-to Code");
            SalesOrderLine.Get(SalesOrderLine."document type"::Order,"Sales Order No.","Sales Order Line No.");
            SalesOrderLine.TestField(Type,SalesOrderLine.Type::Item);
            if SalesOrderLine."Purch. Order Line No." <> 0 then
              Error(Text006,SalesOrderLine."No.",SalesOrderLine."Document No.",SalesOrderLine."Purchase Order No.");
            if SalesOrderLine."Special Order Purchase No." <> '' then
              Error(Text006,SalesOrderLine."No.",SalesOrderLine."Document No.",SalesOrderLine."Special Order Purchase No.");
            if not PurchOrderLine."Special Order" then
              TestField("Sell-to Customer No.",SalesOrderLine."Sell-to Customer No.");
            TestField(Type,SalesOrderLine.Type);
            TestField(
              Quantity,
              ROUND(
                SalesOrderLine."Outstanding Quantity" *
                SalesOrderLine."Qty. per Unit of Measure" /
                "Qty. per Unit of Measure",
                0.00001));
            TestField("No.",SalesOrderLine."No.");
            TestField("Location Code",SalesOrderLine."Location Code");
            TestField("Variant Code",SalesOrderLine."Variant Code");
            TestField("Bin Code",SalesOrderLine."Bin Code");
            TestField("Prod. Order No.",'');
            TestField("Qty. per Unit of Measure","Qty. per Unit of Measure");
            SalesOrderLine.Validate("Unit Cost (LCY)");

            if SalesOrderLine."Special Order" then begin
              SalesOrderLine."Special Order Purchase No." := PurchOrderLine."Document No.";
              SalesOrderLine."Special Order Purch. Line No." := PurchOrderLine."Line No.";
            end else begin
              SalesOrderLine."Purchase Order No." := PurchOrderLine."Document No.";
              SalesOrderLine."Purch. Order Line No." := PurchOrderLine."Line No.";
            end;
            SalesOrderLine.Modify;
          end;

          if TransferExtendedText.PurchCheckIfAnyExtText(PurchOrderLine,false) then begin
            TransferExtendedText.InsertPurchExtText(PurchOrderLine);
            PurchOrderLine2.SetRange("Document Type",PurchOrderHeader."Document Type");
            PurchOrderLine2.SetRange("Document No.",PurchOrderHeader."No.");
            if PurchOrderLine2.FindLast then
              NextLineNo := PurchOrderLine2."Line No.";
          end;
          if PurchasingCode."Special Order" and
             ((PurchSetup."Combine Special Orders Default" =
               PurchSetup."combine special orders default"::"Never Combine") and
               not PurchasingParametersMatch(PurchOrderHeader,ReqLine2))
          then begin
            CarryOutAction.SetPrintOrder(PrintPurchOrders);
            CarryOutAction.PrintPurchaseOrder(PurchOrderHeader);
          end;
        end;
    end;

    local procedure InsertHeader(var ReqLine2: Record "Requisition Line")
    var
        SalesHeader: Record "Sales Header";
        Vendor: Record Vendor;
        SpecialOrder: Boolean;
    begin
        with ReqLine2 do begin
          OrderCounter := OrderCounter + 1;
          if not PlanningResiliency then
            Window.Update(3,OrderCounter);

          PurchSetup.Get;
          PurchSetup.TestField("Order Nos.");
          Clear(PurchOrderHeader);
          PurchOrderHeader.Init;
          PurchOrderHeader."Document Type" := PurchOrderHeader."document type"::Order;
          PurchOrderHeader."No." := '';
          PurchOrderHeader."Posting Date" := PostingDateReq;
          PurchOrderHeader.Insert(true);
          CheckAddressDetails(PurchOrderHeader,"Sales Order No.");
          PurchOrderHeader."Your Reference" := ReferenceReq;
          PurchOrderHeader."Order Date" := OrderDateReq;
          PurchOrderHeader."Expected Receipt Date" := ReceiveDateReq;
          PurchOrderHeader.Validate("Buy-from Vendor No.","Vendor No.");
          if "Order Address Code" <> '' then
            PurchOrderHeader.Validate("Order Address Code","Order Address Code");

          if "Sell-to Customer No." <> '' then
            PurchOrderHeader.Validate("Sell-to Customer No.","Sell-to Customer No.");

          PurchOrderHeader.Validate("Currency Code","Currency Code");

          if PurchasingCode.Get("Purchasing Code") then
            if PurchasingCode."Special Order" then
              SpecialOrder := true;

          if not SpecialOrder then begin
            if "Ship-to Code" <> '' then
              PurchOrderHeader.Validate("Ship-to Code","Ship-to Code")
            else
              PurchOrderHeader.Validate("Location Code","Location Code");
          end else begin
            PurchOrderHeader.Validate("Location Code","Location Code");
            PurchOrderHeader.SetShipToForSpecOrder;
            if Vendor.Get(PurchOrderHeader."Buy-from Vendor No.") then
              PurchOrderHeader.Validate("Shipment Method Code",Vendor."Shipment Method Code");
          end;
          if not SpecialOrder then
            if SalesHeader.Get(SalesHeader."document type"::Order,"Sales Order No.") then begin
              PurchOrderHeader."Ship-to Name" := SalesHeader."Ship-to Name";
              PurchOrderHeader."Ship-to Name 2" := SalesHeader."Ship-to Name 2";
              PurchOrderHeader."Ship-to Address" := SalesHeader."Ship-to Address";
              PurchOrderHeader."Ship-to Address 2" := SalesHeader."Ship-to Address 2";
              PurchOrderHeader."Ship-to Post Code" := SalesHeader."Ship-to Post Code";
              PurchOrderHeader."Ship-to City" := SalesHeader."Ship-to City";
              PurchOrderHeader."Ship-to Contact" := SalesHeader."Ship-to Contact";
            end;
          if SpecialOrder then
            if Vendor.Get(PurchOrderHeader."Buy-from Vendor No.") then
              PurchOrderHeader."Shipment Method Code" := Vendor."Shipment Method Code";
          PurchOrderHeader.Modify;
          Commit;
          LockTable;
          PurchOrderHeader.Mark(true);
        end;
    end;

    local procedure FinalizeOrderHeader(PurchOrderHeader: Record "Purchase Header";var ReqLine: Record "Requisition Line")
    var
        ReqLine2: Record "Requisition Line";
        CarryOutAction: Codeunit "Carry Out Action";
    begin
        if ReqTemplate.Recurring then begin
          // Recurring journal
          ReqLine2.Copy(ReqLine);
          ReqLine2.SetRange("Vendor No.",PurchOrderHeader."Buy-from Vendor No.");
          ReqLine2.SetRange("Location Code",PurchOrderHeader."Location Code");
          ReqLine2.SetRange("Sell-to Customer No.",PurchOrderHeader."Sell-to Customer No.");
          ReqLine2.SetRange("Ship-to Code",PurchOrderHeader."Ship-to Code");
          ReqLine2.SetRange("Order Address Code",PurchOrderHeader."Order Address Code");
          ReqLine2.SetRange("Currency Code",PurchOrderHeader."Currency Code");
          ReqLine2.Find('-');
          repeat
            OrderLineCounter := OrderLineCounter + 1;
            if not PlanningResiliency then
              Window.Update(5,OrderLineCounter);
            if ReqLine2."Order Date" <> 0D then begin
              ReqLine2.Validate(
                "Order Date",
                CalcDate(ReqLine2."Recurring Frequency",ReqLine2."Order Date"));
              ReqLine2.Validate("Currency Code",PurchOrderHeader."Currency Code");
            end;
            if (ReqLine2."Recurring Method" = ReqLine2."recurring method"::Variable) and
               (ReqLine2."No." <> '')
            then begin
              ReqLine2.Quantity := 0;
              ReqLine2."Line Discount %" := 0;
            end;
            ReqLine2.Modify;
          until ReqLine2.Next = 0;
        end else begin
          // Not a recurring journal
          OrderLineCounter := OrderLineCounter + LineCount;
          if not PlanningResiliency then
            Window.Update(5,OrderLineCounter);
          ReqLine2.Copy(ReqLine);
          ReqLine2.SetRange("Vendor No.",PurchOrderHeader."Buy-from Vendor No.");
          ReqLine2.SetRange("Location Code",PurchOrderHeader."Location Code");
          ReqLine2.SetRange("Sell-to Customer No.",PurchOrderHeader."Sell-to Customer No.");
          ReqLine2.SetRange("Ship-to Code",PurchOrderHeader."Ship-to Code");
          ReqLine2.SetRange("Order Address Code",PurchOrderHeader."Order Address Code");
          ReqLine2.SetRange("Currency Code",PurchOrderHeader."Currency Code");
          ReqLine2.SetRange("Purchasing Code",PrevPurchCode);
          if ReqLine2.Find('-') then begin
            ReqLine2.BlockDynamicTracking(true);
            ReservEntry.SetCurrentkey(
              "Source ID","Source Ref. No.","Source Type","Source Subtype",
              "Source Batch Name","Source Prod. Order Line");
            repeat
              TempFailedReqLine := ReqLine2;
              if not TempFailedReqLine.Find then begin
                ReserveReqLine.FilterReservFor(ReservEntry,ReqLine2);
                ReservEntry.DeleteAll(true);
                ReqLine2.Delete(true);
              end;
            until ReqLine2.Next = 0;
            if IsSpecOrder(ReqLine) then begin
              PurchOrderHeader."Sell-to Customer No." := '';
              PurchOrderHeader.Modify;
            end;
          end;
        end;
        Commit;

        CarryOutAction.SetPrintOrder(PrintPurchOrders);
        CarryOutAction.PrintPurchaseOrder(PurchOrderHeader);
    end;

    local procedure CheckRecurringLine(var ReqLine2: Record "Requisition Line")
    var
        DummyDateFormula: DateFormula;
    begin
        with ReqLine2 do begin
          if "No." <> '' then
            if ReqTemplate.Recurring then begin
              TestField("Recurring Method");
              TestField("Recurring Frequency");
              if "Recurring Method" = "recurring method"::Variable then
                TestField(Quantity);
            end else begin
              TestField("Recurring Method",0);
              TestField("Recurring Frequency",DummyDateFormula);
            end;
        end;
    end;

    local procedure MakeRecurringTexts(var ReqLine2: Record "Requisition Line")
    begin
        with ReqLine2 do begin
          if ("No." <> '') and ("Recurring Method" <> 0) and ("Order Date" <> 0D) then begin
            Day := Date2dmy("Order Date",1);
            Week := Date2dwy("Order Date",2);
            Month := Date2dmy("Order Date",2);
            MonthText := Format("Order Date",0,Text007);
            AccountingPeriod.SetRange("Starting Date",0D,"Order Date");
            if not AccountingPeriod.FindLast then
              AccountingPeriod.Name := '';
            Description :=
              DelChr(
                PadStr(
                  StrSubstNo(Description,Day,Week,Month,MonthText,AccountingPeriod.Name),
                  MaxStrLen(Description)),
                '>');
          end;
        end;
    end;

    local procedure ReserveBindingOrderToPurch(var PurchLine: Record "Purchase Line";var ReqLine: Record "Requisition Line")
    var
        ProdOrderComp: Record "Prod. Order Component";
        SalesLine: Record "Sales Line";
        ServLine: Record "Service Line";
        JobPlanningLine: Record "Job Planning Line";
        AsmLine: Record "Assembly Line";
        ProdOrderCompReserve: Codeunit "Prod. Order Comp.-Reserve";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        ServLineReserve: Codeunit "Service Line-Reserve";
        JobPlanningLineReserve: Codeunit "Job Planning Line-Reserve";
        AsmLineReserve: Codeunit "Assembly Line-Reserve";
        ReservQty: Decimal;
        ReservQtyBase: Decimal;
    begin
        PurchLine.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
        if (PurchLine."Quantity (Base)" - PurchLine."Reserved Qty. (Base)") > ReqLine."Demand Quantity (Base)" then begin
          ReservQty := ReqLine."Demand Quantity";
          ReservQtyBase := ReqLine."Demand Quantity (Base)";
        end else begin
          ReservQty := PurchLine.Quantity - PurchLine."Reserved Quantity";
          ReservQtyBase := PurchLine."Quantity (Base)" - PurchLine."Reserved Qty. (Base)";
        end;

        case ReqLine."Demand Type" of
          Database::"Prod. Order Component":
            begin
              ProdOrderComp.Get(
                ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.",ReqLine."Demand Ref. No.");
              ProdOrderCompReserve.BindToPurchase(ProdOrderComp,PurchLine,ReservQty,ReservQtyBase);
            end;
          Database::"Sales Line":
            begin
              SalesLine.Get(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
              SalesLineReserve.BindToPurchase(SalesLine,PurchLine,ReservQty,ReservQtyBase);
              if SalesLine.Reserve = SalesLine.Reserve::Never then begin
                SalesLine.Reserve := SalesLine.Reserve::Optional;
                SalesLine.Modify;
              end;
            end;
          Database::"Service Line":
            begin
              ServLine.Get(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
              ServLineReserve.BindToPurchase(ServLine,PurchLine,ReservQty,ReservQtyBase);
              if ServLine.Reserve = ServLine.Reserve::Never then begin
                ServLine.Reserve := ServLine.Reserve::Optional;
                ServLine.Modify;
              end;
            end;
          Database::"Job Planning Line":
            begin
              JobPlanningLine.SetRange("Job Contract Entry No.",ReqLine."Demand Line No.");
              JobPlanningLine.FindFirst;
              JobPlanningLineReserve.BindToPurchase(JobPlanningLine,PurchLine,ReservQty,ReservQtyBase);
              if JobPlanningLine.Reserve = JobPlanningLine.Reserve::Never then begin
                JobPlanningLine.Reserve := JobPlanningLine.Reserve::Optional;
                JobPlanningLine.Modify;
              end;
            end;
          Database::"Assembly Line":
            begin
              AsmLine.Get(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
              AsmLineReserve.BindToPurchase(AsmLine,PurchLine,ReservQty,ReservQtyBase);
              if AsmLine.Reserve = AsmLine.Reserve::Never then begin
                AsmLine.Reserve := AsmLine.Reserve::Optional;
                AsmLine.Modify;
              end;
            end;
        end;
        PurchLine.Modify;
    end;


    procedure SetTryParam(TryReqTemplate: Record "Req. Wksh. Template";TryLineCount: Integer;TryNextLineNo: Integer;TryPrevPurchCode: Code[10];TryPrevShipToCode: Code[10];TryOrderCounter: Integer;TryOrderLineCounter: Integer;var TryFailedReqLine: Record "Requisition Line")
    begin
        SetPlanningResiliency;
        ReqTemplate := TryReqTemplate;
        LineCount := TryLineCount;
        NextLineNo := TryNextLineNo;
        PrevPurchCode := TryPrevPurchCode;
        PrevShipToCode := TryPrevShipToCode;
        OrderCounter := TryOrderCounter;
        OrderLineCounter := TryOrderLineCounter;
        if TryFailedReqLine.Find('-') then
          repeat
            TempFailedReqLine := TryFailedReqLine;
            if TempFailedReqLine.Insert then;
          until TryFailedReqLine.Next = 0;
    end;


    procedure GetTryParam(var TryPurchOrderHeader: Record "Purchase Header";var TryLineCount: Integer;var TryNextLineNo: Integer;var TryPrevPurchCode: Code[10];var TryPrevShipToCode: Code[10];var TryOrderCounter: Integer;var TryOrderLineCounter: Integer)
    begin
        TryPurchOrderHeader.Copy(PurchOrderHeader);
        TryLineCount := LineCount;
        TryNextLineNo := NextLineNo;
        TryPrevPurchCode := PrevPurchCode;
        TryPrevShipToCode := PrevShipToCode;
        TryOrderCounter := OrderCounter;
        TryOrderLineCounter := OrderLineCounter;
    end;


    procedure SetFailedReqLine(var TryFailedReqLine: Record "Requisition Line")
    begin
        TempFailedReqLine := TryFailedReqLine;
        TempFailedReqLine.Insert;
    end;


    procedure SetPlanningResiliency()
    begin
        PlanningResiliency := true;
    end;


    procedure GetFailedCounter(): Integer
    begin
        exit(CounterFailed);
    end;

    local procedure PrintTransOrder(TransferHeader: Record "Transfer Header")
    var
        CarryOutAction: Codeunit "Carry Out Action";
    begin
        if TransferHeader."No." <> '' then begin
          CarryOutAction.SetPrintOrder(PrintPurchOrders);
          CarryOutAction.PrintTransferOrder(TransferHeader);
        end;
    end;

    local procedure PrintChangedDocument(OrderType: Option;var OrderNo: Code[20])
    var
        DummyReqLine: Record "Requisition Line";
        TransferHeader: Record "Transfer Header";
        PurchaseHeader: Record "Purchase Header";
        CarryOutAction: Codeunit "Carry Out Action";
    begin
        CarryOutAction.SetPrintOrder(PrintPurchOrders);
        case OrderType of
          DummyReqLine."ref. order type"::Transfer:
            begin
              TransferHeader.Get(OrderNo);
              PrintTransOrder(TransferHeader);
            end;
          DummyReqLine."ref. order type"::Purchase:
            begin
              PurchaseHeader.Get(PurchaseHeader."document type"::Order,OrderNo);
              PrintPurchOrder(PurchaseHeader);
            end;
        end;
        OrderNo := '';
    end;

    local procedure PrintPurchOrder(PurchHeader: Record "Purchase Header")
    var
        CarryOutAction: Codeunit "Carry Out Action";
    begin
        if PurchHeader."No." <> '' then begin
          CarryOutAction.SetPrintOrder(PrintPurchOrders);
          CarryOutAction.PrintPurchaseOrder(PurchHeader);
        end;
    end;

    local procedure SetPurchOrderHeader()
    begin
        PurchOrderHeader."Order Date" := OrderDateReq;
        PurchOrderHeader."Posting Date" := PostingDateReq;
        PurchOrderHeader."Expected Receipt Date" := ReceiveDateReq;
        PurchOrderHeader."Your Reference" := ReferenceReq;
    end;

    local procedure CheckAddressDetails(var PurchaseHeader: Record "Purchase Header";SalesOrderNo: Code[20]) Result: Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(SalesHeader."document type"::Order,SalesOrderNo) then begin
          if PurchaseHeader.DropShptOrderExists(SalesHeader) then
            Result :=
              not PurchaseHeader.CheckDropShptAddressDetails(SalesHeader);
          if PurchaseHeader.SpecialOrderExists(SalesHeader) then
            Result :=
              not PurchaseHeader.CheckSpecOrderAddressDetails(SalesHeader);
        end;
    end;

    local procedure IsSpecOrder(ReqLine: Record "Requisition Line"): Boolean
    var
        PurchCode: Record Purchasing;
    begin
        if PurchOrderHeader.Find then
          if PurchCode.Get(ReqLine."Purchasing Code") then
            exit(PurchasingCode."Special Order");
    end;

    local procedure PurchasingParametersMatch(PurchaseHeader: Record "Purchase Header";ReqLine: Record "Requisition Line"): Boolean
    begin
        exit(
          (PurchaseHeader."Buy-from Vendor No." = ReqLine."Vendor No.") and
          (PrevLocationCode = ReqLine."Location Code") and
          (PurchaseHeader."Currency Code" = ReqLine."Currency Code") and
          (PrevPurchCode = ReqLine."Purchasing Code"));
    end;
}

