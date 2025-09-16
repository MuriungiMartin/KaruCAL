#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5520 "Get Unplanned Demand"
{
    TableNo = "Unplanned Demand";

    trigger OnRun()
    begin
        DeleteAll;
        SalesLine.SetFilter(
          "Document Type",'%1|%2',
          SalesLine."document type"::Order,
          SalesLine."document type"::"Return Order");
        ProdOrderComp.SetFilter(
          Status,'%1|%2|%3',
          ProdOrderComp.Status::Planned,
          ProdOrderComp.Status::"Firm Planned",
          ProdOrderComp.Status::Released);
        ServLine.SetRange("Document Type",ServLine."document type"::Order);
        AsmLine.SetRange("Document Type",AsmLine."document type"::Order);
        JobPlanningLine.SetRange(Status,JobPlanningLine.Status::Order);

        OpenWindow(Text000,SalesLine.Count + ProdOrderComp.Count + ServLine.Count + JobPlanningLine.Count);
        GetUnplannedSalesLine(Rec);
        GetUnplannedProdOrderComp(Rec);
        GetUnplannedAsmLine(Rec);
        GetUnplannedServLine(Rec);
        GetUnplannedJobPlanningLine(Rec);
        Window.Close;

        Reset;
        SetCurrentkey("Demand Date",Level);
        SetRange(Level,1);
        OpenWindow(Text000,Count);
        CalcNeededDemands(Rec);
        Window.Close;
    end;

    var
        SalesLine: Record "Sales Line";
        ProdOrderComp: Record "Prod. Order Component";
        Text000: label 'Determining Unplanned Orders @1@@@@@@@';
        ServLine: Record "Service Line";
        JobPlanningLine: Record "Job Planning Line";
        AsmLine: Record "Assembly Line";
        Window: Dialog;
        WindowUpdateDateTime: DateTime;
        NoOfRecords: Integer;
        i: Integer;
        DemandQtyBase: Decimal;

    local procedure GetUnplannedSalesLine(var UnplannedDemand: Record "Unplanned Demand")
    var
        SalesHeader: Record "Sales Header";
    begin
        with UnplannedDemand do
          if SalesLine.Find('-') then
            repeat
              UpdateWindow;

              DemandQtyBase := GetSalesLineNeededQty(SalesLine);
              if DemandQtyBase > 0 then begin
                if not ((SalesLine."Document Type" = "Demand SubType") and
                        (SalesLine."Document No." = "Demand Order No."))
                then begin
                  SalesHeader.Get(SalesLine."Document Type",SalesLine."Document No.");

                  Init;
                  "Demand Type" := "demand type"::Sales;
                  "Demand SubType" := SalesLine."Document Type";
                  Validate("Demand Order No.",SalesLine."Document No.");
                  Status := SalesHeader.Status;
                  Level := 0;
                  Insert;
                end;
                InsertSalesLine(UnplannedDemand);
              end;
            until SalesLine.Next = 0;
    end;

    local procedure GetUnplannedProdOrderComp(var UnplannedDemand: Record "Unplanned Demand")
    begin
        with UnplannedDemand do
          if ProdOrderComp.Find('-') then
            repeat
              UpdateWindow;

              DemandQtyBase := GetProdOrderCompNeededQty(ProdOrderComp);
              if DemandQtyBase > 0 then begin
                if not ((ProdOrderComp.Status = "Demand SubType") and
                        (ProdOrderComp."Prod. Order No." = "Demand Order No."))
                then begin
                  Init;
                  "Demand Type" := "demand type"::Production;
                  "Demand SubType" := ProdOrderComp.Status;
                  Validate("Demand Order No.",ProdOrderComp."Prod. Order No.");
                  Status := ProdOrderComp.Status;
                  Level := 0;
                  Insert;
                end;
                InsertProdOrderCompLine(UnplannedDemand);
              end;
            until ProdOrderComp.Next = 0;
    end;

    local procedure GetUnplannedAsmLine(var UnplannedDemand: Record "Unplanned Demand")
    var
        AsmHeader: Record "Assembly Header";
    begin
        with UnplannedDemand do
          if AsmLine.Find('-') then
            repeat
              UpdateWindow;

              DemandQtyBase := GetAsmLineNeededQty(AsmLine);
              if DemandQtyBase > 0 then begin
                if not ((AsmLine."Document Type" = "Demand SubType") and
                        (AsmLine."Document No." = "Demand Order No."))
                then begin
                  AsmHeader.Get(AsmLine."Document Type",AsmLine."Document No.");

                  Init;
                  "Demand Type" := "demand type"::Assembly;
                  "Demand SubType" := AsmLine."Document Type";
                  Validate("Demand Order No.",AsmLine."Document No.");
                  Status := AsmHeader.Status;
                  Level := 0;
                  Insert;
                end;
                InsertAsmLine(UnplannedDemand);
              end;
            until AsmLine.Next = 0;
    end;

    local procedure GetUnplannedServLine(var UnplannedDemand: Record "Unplanned Demand")
    var
        ServHeader: Record "Service Header";
    begin
        with UnplannedDemand do
          if ServLine.Find('-') then
            repeat
              UpdateWindow;

              DemandQtyBase := GetServLineNeededQty(ServLine);
              if DemandQtyBase > 0 then begin
                if not ((ServLine."Document Type" = "Demand SubType") and
                        (ServLine."Document No." = "Demand Order No."))
                then begin
                  ServHeader.Get(ServLine."Document Type",ServLine."Document No.");

                  Init;
                  "Demand Type" := "demand type"::Service;
                  "Demand SubType" := ServLine."Document Type";
                  Validate("Demand Order No.",ServLine."Document No.");
                  Status := ServHeader.Status;
                  Level := 0;
                  Insert;
                end;
                InsertServLine(UnplannedDemand);
              end;
            until ServLine.Next = 0;
    end;

    local procedure GetUnplannedJobPlanningLine(var UnplannedDemand: Record "Unplanned Demand")
    var
        Job: Record Job;
    begin
        with UnplannedDemand do
          if JobPlanningLine.Find('-') then
            repeat
              UpdateWindow;

              DemandQtyBase := GetJobPlanningLineNeededQty(JobPlanningLine);
              if DemandQtyBase > 0 then begin
                if not ((JobPlanningLine.Status = "Demand SubType") and
                        (JobPlanningLine."Job No." = "Demand Order No."))
                then begin
                  Job.Get(JobPlanningLine."Job No.");

                  Init;
                  "Demand Type" := "demand type"::Job;
                  "Demand SubType" := JobPlanningLine.Status;
                  Validate("Demand Order No.",JobPlanningLine."Job No.");
                  Status := Job.Status;
                  Level := 0;
                  Insert;
                end;
                InsertJobPlanningLine(UnplannedDemand);
              end;
            until JobPlanningLine.Next = 0;
    end;

    local procedure GetSalesLineNeededQty(SalesLine: Record "Sales Line"): Decimal
    begin
        with SalesLine do begin
          if Planned or ("No." = '') or (Type <> Type::Item) or "Drop Shipment" or "Special Order" or IsServiceItem then
            exit(0);

          CalcFields("Reserved Qty. (Base)");
          exit(-SignedXX("Outstanding Qty. (Base)" - "Reserved Qty. (Base)"));
        end;
    end;

    local procedure GetProdOrderCompNeededQty(ProdOrderComp: Record "Prod. Order Component"): Decimal
    begin
        with ProdOrderComp do begin
          if "Item No." = '' then
            exit(0);

          CalcFields("Reserved Qty. (Base)");
          exit("Remaining Qty. (Base)" - "Reserved Qty. (Base)");
        end;
    end;

    local procedure GetAsmLineNeededQty(AsmLine: Record "Assembly Line"): Decimal
    begin
        with AsmLine do begin
          if ("No." = '') or (Type <> Type::Item) then
            exit(0);

          CalcFields("Reserved Qty. (Base)");
          exit(-SignedXX("Remaining Quantity (Base)" - "Reserved Qty. (Base)"));
        end;
    end;

    local procedure GetServLineNeededQty(ServLine: Record "Service Line"): Decimal
    begin
        with ServLine do begin
          if Planned or ("No." = '') or (Type <> Type::Item) then
            exit(0);

          CalcFields("Reserved Qty. (Base)");
          exit(-SignedXX("Outstanding Qty. (Base)" - "Reserved Qty. (Base)"));
        end;
    end;

    local procedure GetJobPlanningLineNeededQty(JobPlanningLine: Record "Job Planning Line"): Decimal
    begin
        with JobPlanningLine do begin
          if Planned or ("No." = '') or (Type <> Type::Item) then
            exit(0);

          CalcFields("Reserved Qty. (Base)");
          exit("Remaining Qty. (Base)" - "Reserved Qty. (Base)");
        end;
    end;

    local procedure InsertSalesLine(var UnplannedDemand: Record "Unplanned Demand")
    var
        UnplannedDemand2: Record "Unplanned Demand";
    begin
        with UnplannedDemand do begin
          UnplannedDemand2.Copy(UnplannedDemand);

          "Demand Line No." := SalesLine."Line No.";
          "Demand Ref. No." := 0;
          "Item No." := SalesLine."No.";
          Description := SalesLine.Description;
          "Variant Code" := SalesLine."Variant Code";
          "Location Code" := SalesLine."Location Code";
          "Bin Code" := SalesLine."Bin Code";
          "Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
          "Unit of Measure Code" := SalesLine."Unit of Measure Code";
          Reserve := SalesLine.Reserve = SalesLine.Reserve::Always;
          "Special Order" := SalesLine."Special Order";
          "Purchasing Code" := SalesLine."Purchasing Code";
          Level := 1;

          "Quantity (Base)" := DemandQtyBase;
          "Demand Date" := SalesLine."Shipment Date";
          if "Demand Date" = 0D then
            "Demand Date" := WorkDate;

          Insert;

          Copy(UnplannedDemand2);
        end;
    end;

    local procedure InsertProdOrderCompLine(var UnplannedDemand: Record "Unplanned Demand")
    var
        UnplannedDemand2: Record "Unplanned Demand";
        Item: Record Item;
    begin
        with UnplannedDemand do begin
          UnplannedDemand2.Copy(UnplannedDemand);

          "Demand Line No." := ProdOrderComp."Prod. Order Line No.";
          "Demand Ref. No." := ProdOrderComp."Line No.";
          "Item No." := ProdOrderComp."Item No.";
          Description := ProdOrderComp.Description;
          "Variant Code" := ProdOrderComp."Variant Code";
          "Location Code" := ProdOrderComp."Location Code";
          "Bin Code" := ProdOrderComp."Bin Code";
          "Qty. per Unit of Measure" := ProdOrderComp."Qty. per Unit of Measure";
          "Unit of Measure Code" := ProdOrderComp."Unit of Measure Code";
          Item.Get("Item No.");
          Reserve :=
            (Item.Reserve = Item.Reserve::Always) and
            not (("Demand Type" = "demand type"::Production) and
                 ("Demand SubType" = ProdOrderComp.Status::Planned));
          Level := 1;

          "Quantity (Base)" := DemandQtyBase;
          "Demand Date" := ProdOrderComp."Due Date";
          if "Demand Date" = 0D then
            "Demand Date" := WorkDate;

          Insert;

          Copy(UnplannedDemand2);
        end;
    end;

    local procedure InsertAsmLine(var UnplannedDemand: Record "Unplanned Demand")
    var
        UnplannedDemand2: Record "Unplanned Demand";
    begin
        with UnplannedDemand do begin
          UnplannedDemand2.Copy(UnplannedDemand);

          "Demand Line No." := AsmLine."Line No.";
          "Demand Ref. No." := 0;
          "Item No." := AsmLine."No.";
          Description := AsmLine.Description;
          "Variant Code" := AsmLine."Variant Code";
          "Location Code" := AsmLine."Location Code";
          "Bin Code" := AsmLine."Bin Code";
          "Qty. per Unit of Measure" := AsmLine."Qty. per Unit of Measure";
          "Unit of Measure Code" := AsmLine."Unit of Measure Code";
          Reserve := AsmLine.Reserve = AsmLine.Reserve::Always;
          Level := 1;

          "Quantity (Base)" := DemandQtyBase;
          "Demand Date" := AsmLine."Due Date";
          if "Demand Date" = 0D then
            "Demand Date" := WorkDate;

          Insert;

          Copy(UnplannedDemand2);
        end;
    end;

    local procedure InsertServLine(var UnplannedDemand: Record "Unplanned Demand")
    var
        UnplannedDemand2: Record "Unplanned Demand";
    begin
        with UnplannedDemand do begin
          UnplannedDemand2.Copy(UnplannedDemand);

          "Demand Line No." := ServLine."Line No.";
          "Demand Ref. No." := 0;
          "Item No." := ServLine."No.";
          Description := ServLine.Description;
          "Variant Code" := ServLine."Variant Code";
          "Location Code" := ServLine."Location Code";
          "Bin Code" := ServLine."Bin Code";
          "Qty. per Unit of Measure" := ServLine."Qty. per Unit of Measure";
          "Unit of Measure Code" := ServLine."Unit of Measure Code";
          Reserve := ServLine.Reserve = ServLine.Reserve::Always;
          Level := 1;

          "Quantity (Base)" := DemandQtyBase;
          "Demand Date" := ServLine."Needed by Date";
          if "Demand Date" = 0D then
            "Demand Date" := WorkDate;

          Insert;

          Copy(UnplannedDemand2);
        end;
    end;

    local procedure InsertJobPlanningLine(var UnplannedDemand: Record "Unplanned Demand")
    var
        UnplannedDemand2: Record "Unplanned Demand";
    begin
        with UnplannedDemand do begin
          UnplannedDemand2.Copy(UnplannedDemand);

          "Demand Line No." := JobPlanningLine."Job Contract Entry No.";
          "Demand Ref. No." := 0;
          "Item No." := JobPlanningLine."No.";
          Description := JobPlanningLine.Description;
          "Variant Code" := JobPlanningLine."Variant Code";
          "Location Code" := JobPlanningLine."Location Code";
          "Bin Code" := JobPlanningLine."Bin Code";
          "Qty. per Unit of Measure" := JobPlanningLine."Qty. per Unit of Measure";
          "Unit of Measure Code" := JobPlanningLine."Unit of Measure Code";
          Reserve := JobPlanningLine.Reserve = JobPlanningLine.Reserve::Always;
          Level := 1;

          "Quantity (Base)" := DemandQtyBase;
          "Demand Date" := JobPlanningLine."Planning Date";
          if "Demand Date" = 0D then
            "Demand Date" := WorkDate;

          Insert;

          Copy(UnplannedDemand2);
        end;
    end;

    local procedure CalcNeededDemands(var UnplannedDemand: Record "Unplanned Demand")
    var
        TempUnplannedDemand: Record "Unplanned Demand" temporary;
        OrderPlanningMgt: Codeunit "Order Planning Mgt.";
        HeaderExists: Boolean;
    begin
        with TempUnplannedDemand do begin
          UnplannedDemand.Reset;
          MoveUnplannedDemand(UnplannedDemand,TempUnplannedDemand);

          SetCurrentkey("Demand Date",Level);
          SetRange(Level,1);
          while Find('-') do begin
            HeaderExists := false;
            repeat
              UpdateWindow;
              UnplannedDemand := TempUnplannedDemand;
              if UnplannedDemand."Special Order" then
                UnplannedDemand."Needed Qty. (Base)" := "Quantity (Base)"
              else
                UnplannedDemand."Needed Qty. (Base)" :=
                  OrderPlanningMgt.CalcNeededQty(
                    OrderPlanningMgt.CalcATPQty("Item No.","Variant Code","Location Code","Demand Date") +
                    CalcUnplannedDemandInSameDay(TempUnplannedDemand) +
                    CalcPlannedDemand(UnplannedDemand),
                    "Quantity (Base)");

              if UnplannedDemand."Needed Qty. (Base)" > 0 then begin
                UnplannedDemand.Insert;
                if not HeaderExists then begin
                  InsertUnplannedDemandHeader(TempUnplannedDemand,UnplannedDemand);
                  HeaderExists := true;
                  SetRange("Demand Type","Demand Type");
                  SetRange("Demand SubType","Demand SubType");
                  SetRange("Demand Order No.","Demand Order No.");
                end;
              end;
              Delete;
            until Next = 0;
            SetRange("Demand Type");
            SetRange("Demand SubType");
            SetRange("Demand Order No.");
          end;
        end;
    end;

    local procedure CalcPlannedDemand(var UnplannedDemand: Record "Unplanned Demand") DemandQty: Decimal
    var
        UnplannedDemand2: Record "Unplanned Demand";
    begin
        with UnplannedDemand do begin
          UnplannedDemand2.Copy(UnplannedDemand);
          Reset;
          SetCurrentkey("Item No.","Variant Code","Location Code","Demand Date");
          SetRange("Item No.","Item No.");
          SetRange("Variant Code","Variant Code");
          SetRange("Location Code","Location Code");
          SetRange("Demand Date",0D,"Demand Date");

          CalcSums("Needed Qty. (Base)");
          DemandQty := "Needed Qty. (Base)";
          Copy(UnplannedDemand2);
        end;
    end;

    local procedure CalcUnplannedDemandInSameDay(var UnplannedDemand: Record "Unplanned Demand") DemandQty: Decimal
    var
        UnplannedDemand2: Record "Unplanned Demand";
    begin
        with UnplannedDemand do begin
          UnplannedDemand2.Copy(UnplannedDemand);
          Reset;
          SetCurrentkey("Item No.","Variant Code","Location Code","Demand Date");
          SetRange("Item No.","Item No.");
          SetRange("Variant Code","Variant Code");
          SetRange("Location Code","Location Code");
          SetRange("Demand Date","Demand Date");

          CalcSums("Quantity (Base)");
          DemandQty := "Quantity (Base)";

          Copy(UnplannedDemand2);
        end;
    end;

    local procedure MoveUnplannedDemand(var FromUnplannedDemand: Record "Unplanned Demand";var ToUnplannedDemand: Record "Unplanned Demand")
    begin
        with FromUnplannedDemand do begin
          ToUnplannedDemand.DeleteAll;
          if Find('-') then
            repeat
              ToUnplannedDemand := FromUnplannedDemand;
              ToUnplannedDemand.Insert;
              Delete;
            until Next = 0;
        end;
    end;

    local procedure InsertUnplannedDemandHeader(var FromUnplannedDemand: Record "Unplanned Demand";var ToUnplannedDemand: Record "Unplanned Demand")
    var
        UnplannedDemand2: Record "Unplanned Demand";
    begin
        UnplannedDemand2.Copy(FromUnplannedDemand);

        with FromUnplannedDemand do begin
          Reset;
          SetRange("Demand Type","Demand Type");
          SetRange("Demand SubType","Demand SubType");
          SetRange("Demand Order No.","Demand Order No.");
          SetRange(Level,0);
          Find('-');

          ToUnplannedDemand := FromUnplannedDemand;
          ToUnplannedDemand."Demand Date" := UnplannedDemand2."Demand Date";
          ToUnplannedDemand.Insert;
        end;

        FromUnplannedDemand.Copy(UnplannedDemand2);
    end;

    local procedure OpenWindow(DisplayText: Text[250];NoOfRecords2: Integer)
    begin
        i := 0;
        NoOfRecords := NoOfRecords2;
        WindowUpdateDateTime := CurrentDatetime;
        Window.Open(DisplayText);
    end;

    local procedure UpdateWindow()
    begin
        i := i + 1;
        if CurrentDatetime - WindowUpdateDateTime >= 300 then begin
          WindowUpdateDateTime := CurrentDatetime;
          Window.Update(1,ROUND(i / NoOfRecords * 10000,1));
        end;
    end;
}

