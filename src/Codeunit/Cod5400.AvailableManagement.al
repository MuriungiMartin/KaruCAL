#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5400 "Available Management"
{

    trigger OnRun()
    begin
    end;


    procedure ExpectedQtyOnHand(var Item: Record Item;CalcAvailable: Boolean;ExtraNetNeed: Decimal;var Available: Decimal;PlannedOrderReceiptDate: Date): Decimal
    var
        CopyOfItem: Record Item;
    begin
        CopyOfItem.Copy(Item);

        Available := 0;
        if CalcAvailable then
          Available := CalcAvailableQty(Item,true,PlannedOrderReceiptDate) - ExtraNetNeed;
        Item.Copy(CopyOfItem);
        exit(CalcAvailableQty(Item,false,0D) - ExtraNetNeed);
    end;

    local procedure CalcAvailableQty(var Item: Record Item;CalcAvailable: Boolean;PlannedOrderReceiptDate: Date): Decimal
    var
        CopyOfItem: Record Item;
        JobPlanningLine: Record "Job Planning Line";
    begin
        CopyOfItem.Copy(Item);
        with CopyOfItem do begin
          SetRange("Date Filter",0D,GetRangemax("Date Filter"));
          CalcFields(
            "Qty. on Purch. Order",
            "Scheduled Receipt (Qty.)",
            "Trans. Ord. Receipt (Qty.)",
            "Planned Order Receipt (Qty.)",
            "Qty. on Sales Return");

          if GetFilter("Location Filter") <> '' then
            CalcFields("Qty. in Transit");

          if CalcAvailable then
            SetRange("Date Filter",0D,PlannedOrderReceiptDate);
          CalcFields(
            "Qty. on Sales Order",
            "Scheduled Need (Qty.)",
            "Trans. Ord. Shipment (Qty.)",
            "Qty. on Service Order",
            "Qty. on Assembly Order",
            "Qty. on Purch. Return");

          if JobPlanningLine.ReadPermission then
            CalcFields("Qty. on Job Order");

          exit(
            Inventory +
            "Qty. on Purch. Order" -
            "Qty. on Sales Order" -
            "Scheduled Need (Qty.)" +
            "Planned Order Receipt (Qty.)" +
            "Scheduled Receipt (Qty.)" -
            "Trans. Ord. Shipment (Qty.)" +
            "Qty. in Transit" +
            "Trans. Ord. Receipt (Qty.)" -
            "Qty. on Service Order" -
            "Qty. on Job Order" -
            "Qty. on Purch. Return" +
            "Qty. on Assembly Order" +
            "Qty. on Sales Return");
        end;
    end;


    procedure GetItemReorderQty(Item: Record Item;QtyAvailable: Decimal) ReorderQty: Decimal
    begin
        if Item."Reordering Policy" = Item."reordering policy"::" " then
          if Item."Maximum Inventory" <= 0 then begin
            if QtyAvailable > 0 then
              QtyAvailable := 0;
            if Item."Reorder Quantity" > 0 then
              ReorderQty :=
                ROUND((Item."Reorder Point" - QtyAvailable) / Item."Reorder Quantity",1,'>') *
                Item."Reorder Quantity"
            else
              ReorderQty := Item."Reorder Point" - QtyAvailable;
          end
          else
            if (Item."Reorder Point" > Item."Maximum Inventory") or
               ((QtyAvailable + Item."Reorder Quantity") > Item."Maximum Inventory")
            then
              ReorderQty := 0
            else
              if Item."Reorder Quantity" > 0 then
                ReorderQty :=
                  ROUND((Item."Maximum Inventory" - QtyAvailable) / Item."Reorder Quantity",1,'<') *
                  Item."Reorder Quantity"
              else
                ReorderQty := Item."Maximum Inventory" - QtyAvailable
        else begin
          if Item."Reorder Point" > Item."Safety Stock Quantity" then begin
            if QtyAvailable > 0 then
              QtyAvailable := 0;
            ReorderQty := Item."Reorder Point" - QtyAvailable
          end else
            ReorderQty := -QtyAvailable;

          if ReorderQty <= 0 then
            exit(0);

          ReorderQty := CalcReorderQty(Item,ReorderQty,QtyAvailable);
          ReorderQty += AdjustReorderQty(ReorderQty,Item);
        end;
    end;

    local procedure AdjustReorderQty(OrderQty: Decimal;Item: Record Item): Decimal
    var
        DeltaQty: Decimal;
        Rounding: Decimal;
    begin
        // Copy of AdjustReorderQty in COD 99000854 - Inventory Profile Offsetting
        // excluding logging surplus & MinQty check
        if OrderQty <= 0 then
          exit(0);

        if (Item."Maximum Order Quantity" < OrderQty) and
           (Item."Maximum Order Quantity" <> 0)
           // AND  (SKU."Maximum Order Quantity" > MinQty)
        then begin
          DeltaQty := Item."Maximum Order Quantity" - OrderQty;
        end else
          DeltaQty := 0;
        if Item."Minimum Order Quantity" > (OrderQty + DeltaQty) then
          DeltaQty := Item."Minimum Order Quantity" - OrderQty;

        if Item."Order Multiple" <> 0 then begin
          Rounding := ROUND(OrderQty + DeltaQty,Item."Order Multiple",'>') - (OrderQty + DeltaQty);
          DeltaQty += Rounding;
        end;
        exit(DeltaQty);
    end;

    local procedure CalcReorderQty(Item: Record Item;NeededQty: Decimal;ProjectedInventory: Decimal) QtyToOrder: Decimal
    begin
        // Copy of CalcReorderQty in COD 99000854 - Inventory Profile Offsetting
        // excluding logging surplus, resiliency errors and comments
        case Item."Reordering Policy" of
          Item."reordering policy"::"Maximum Qty.":
            begin
              if Item."Maximum Inventory" < Item."Reorder Point" then
                QtyToOrder := Item."Reorder Point" - ProjectedInventory
              else
                QtyToOrder := Item."Maximum Inventory" - ProjectedInventory;
            end;
          Item."reordering policy"::"Fixed Reorder Qty.":
            begin
              Item.TestField("Reorder Quantity"); // Assertion
              QtyToOrder := Item."Reorder Quantity";
            end;
          else
            QtyToOrder := NeededQty;
        end;
    end;
}

