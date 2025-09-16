#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 353 "Item Availability Forms Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        Text012: label 'Do you want to change %1 from %2 to %3?', Comment='%1=FieldCaption, %2=OldDate, %3=NewDate';
        ItemAvailByBOMLevel: Page "Item Availability by BOM Level";
        ForecastName: Code[10];
        AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM;

    local procedure CalcItemPlanningFields(var Item: Record Item)
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        with Item do begin
          Init;
          CalcFields(
            "Qty. on Purch. Order",
            "Qty. on Sales Order",
            "Qty. on Service Order",
            Inventory,
            "Net Change",
            "Scheduled Receipt (Qty.)",
            "Scheduled Need (Qty.)",
            "Planned Order Receipt (Qty.)",
            "FP Order Receipt (Qty.)",
            "Rel. Order Receipt (Qty.)",
            "Planned Order Release (Qty.)",
            "Purch. Req. Receipt (Qty.)",
            "Planning Issues (Qty.)",
            "Purch. Req. Release (Qty.)");

          if JobPlanningLine.ReadPermission then
            CalcFields("Qty. on Job Order");
          CalcFields(
            "Qty. on Assembly Order",
            "Qty. on Asm. Component",
            "Qty. on Purch. Return",
            "Qty. on Sales Return");
          if GetFilter("Location Filter") <> '' then
            CalcFields(
              "Trans. Ord. Shipment (Qty.)",
              "Qty. in Transit",
              "Trans. Ord. Receipt (Qty.)");
        end;
    end;


    procedure CalculateNeed(var Item: Record Item;var GrossRequirement: Decimal;var PlannedOrderReceipt: Decimal;var ScheduledReceipt: Decimal;var PlannedOrderReleases: Decimal)
    begin
        CalcItemPlanningFields(Item);

        with Item do begin
          GrossRequirement :=
            "Qty. on Sales Order" +
            "Qty. on Service Order" +
            "Qty. on Job Order" +
            "Scheduled Need (Qty.)" +
            "Trans. Ord. Shipment (Qty.)" +
            "Planning Issues (Qty.)" +
            "Qty. on Asm. Component" +
            "Qty. on Purch. Return";
          PlannedOrderReceipt :=
            "Planned Order Receipt (Qty.)" +
            "Purch. Req. Receipt (Qty.)";
          ScheduledReceipt :=
            "FP Order Receipt (Qty.)" +
            "Rel. Order Receipt (Qty.)" +
            "Qty. on Purch. Order" +
            "Qty. in Transit" +
            "Trans. Ord. Receipt (Qty.)" +
            "Qty. on Assembly Order" +
            "Qty. on Sales Return";
          PlannedOrderReleases :=
            "Planned Order Release (Qty.)" +
            "Purch. Req. Release (Qty.)";
        end;
    end;

    local procedure CalcProjAvailableBalance(var Item: Record Item): Decimal
    var
        Item2: Record Item;
        GrossRequirement: Decimal;
        PlannedOrderReceipt: Decimal;
        ScheduledReceipt: Decimal;
        PlannedOrderReleases: Decimal;
    begin
        Item2.Copy(Item);
        Item2.SetRange("Date Filter",0D,Item.GetRangemax("Date Filter"));
        CalculateNeed(Item2,GrossRequirement,PlannedOrderReceipt,ScheduledReceipt,PlannedOrderReleases);
        exit(Item2.Inventory + PlannedOrderReceipt + ScheduledReceipt - GrossRequirement);
    end;

    local procedure CalcProjAvailableBalance2(Inventory: Decimal;GrossRequirement: Decimal;PlannedOrderReceipt: Decimal;ScheduledReceipt: Decimal): Decimal
    begin
        exit(Inventory + PlannedOrderReceipt + ScheduledReceipt - GrossRequirement);
    end;


    procedure CalcAvailQuantities(var Item: Record Item;IsBalanceAtDate: Boolean;var GrossRequirement: Decimal;var PlannedOrderRcpt: Decimal;var ScheduledRcpt: Decimal;var PlannedOrderReleases: Decimal;var ProjAvailableBalance: Decimal;var ExpectedInventory: Decimal;var QtyAvailable: Decimal)
    var
        AvailableMgt: Codeunit "Available Management";
    begin
        CalculateNeed(Item,GrossRequirement,PlannedOrderRcpt,ScheduledRcpt,PlannedOrderReleases);
        if IsBalanceAtDate then
          ProjAvailableBalance :=
            CalcProjAvailableBalance2(Item.Inventory,GrossRequirement,PlannedOrderRcpt,ScheduledRcpt)
        else
          ProjAvailableBalance := CalcProjAvailableBalance(Item);
        ExpectedInventory := AvailableMgt.ExpectedQtyOnHand(Item,true,0,QtyAvailable,Dmy2date(31,12,9999));
    end;


    procedure ShowItemLedgerEntries(var Item: Record Item;NetChange: Boolean)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.FindLinesWithItemToPlan(Item,NetChange);
        Page.Run(0,ItemLedgEntry);
    end;


    procedure ShowSalesLines(var Item: Record Item)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.FindLinesWithItemToPlan(Item,SalesLine."document type"::Order);
        Page.Run(0,SalesLine);
    end;


    procedure ShowServLines(var Item: Record Item)
    var
        ServLine: Record "Service Line";
    begin
        ServLine.FindLinesWithItemToPlan(Item);
        Page.Run(0,ServLine);
    end;


    procedure ShowJobPlanningLines(var Item: Record Item)
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        JobPlanningLine.FindLinesWithItemToPlan(Item);
        Page.Run(0,JobPlanningLine);
    end;


    procedure ShowPurchLines(var Item: Record Item)
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.FindLinesWithItemToPlan(Item,PurchLine."document type"::Order);
        Page.Run(0,PurchLine);
    end;


    procedure ShowSchedReceipt(var Item: Record Item)
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        ProdOrderLine.FindLinesWithItemToPlan(Item,true);
        Page.Run(0,ProdOrderLine);
    end;


    procedure ShowSchedNeed(var Item: Record Item)
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        ProdOrderComp.FindLinesWithItemToPlan(Item,true);
        Page.Run(0,ProdOrderComp);
    end;


    procedure ShowTransLines(var Item: Record Item;What: Integer)
    var
        TransLine: Record "Transfer Line";
    begin
        case What of
          Item.FieldNo("Trans. Ord. Shipment (Qty.)"):
            TransLine.FindLinesWithItemToPlan(Item,false,false);
          Item.FieldNo("Qty. in Transit"),
          Item.FieldNo("Trans. Ord. Receipt (Qty.)"):
            TransLine.FindLinesWithItemToPlan(Item,true,false);
        end;
        Page.Run(0,TransLine);
    end;


    procedure ShowAsmOrders(var Item: Record Item)
    var
        AssemblyHeader: Record "Assembly Header";
    begin
        AssemblyHeader.FindLinesWithItemToPlan(Item,AssemblyHeader."document type"::Order);
        Page.Run(0,AssemblyHeader);
    end;


    procedure ShowAsmCompLines(var Item: Record Item)
    var
        AssemblyLine: Record "Assembly Line";
    begin
        AssemblyLine.FindLinesWithItemToPlan(Item,AssemblyLine."document type"::Order);
        Page.Run(0,AssemblyLine);
    end;


    procedure ShowItemAvailLineList(var Item: Record Item;What: Integer)
    var
        ItemAvailLineList: Page "Item Availability Line List";
    begin
        CalcItemPlanningFields(Item);
        ItemAvailLineList.Init(What,Item);
        ItemAvailLineList.RunModal;
    end;


    procedure ShowItemAvailFromItem(var Item: Record Item;AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with Item do begin
          TestField("No.");

          case AvailabilityType of
            Availabilitytype::Date:
              ShowItemAvailByDate(Item,'',NewDate,NewDate);
            Availabilitytype::Variant:
              ShowItemAvailVariant(Item,'',NewVariantCode,NewVariantCode);
            Availabilitytype::Location:
              ShowItemAvailByLoc(Item,'',NewLocationCode,NewLocationCode);
            Availabilitytype::"Event":
              ShowItemAvailByEvent(Item,'',NewDate,NewDate,false);
            Availabilitytype::BOM:
              ShowItemAvailByBOMLevel(Item,'',NewDate,NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromSalesLine(var SalesLine: Record "Sales Line";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        AsmHeader: Record "Assembly Header";
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with SalesLine do begin
          TestField(Type,Type::Item);
          TestField("No.");
          Item.Reset;
          Item.Get("No.");
          FilterItem(Item,"Location Code","Variant Code","Shipment Date");

          case AvailabilityType of
            Availabilitytype::Date:
              if ShowItemAvailByDate(Item,FieldCaption("Shipment Date"),"Shipment Date",NewDate) then
                Validate("Shipment Date",NewDate);
            Availabilitytype::Variant:
              if ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode) then
                Validate("Variant Code",NewVariantCode);
            Availabilitytype::Location:
              if ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode) then
                Validate("Location Code",NewLocationCode);
            Availabilitytype::"Event":
              if ShowItemAvailByEvent(Item,FieldCaption("Shipment Date"),"Shipment Date",NewDate,false) then
                Validate("Shipment Date",NewDate);
            Availabilitytype::BOM:
              if AsmToOrderExists(AsmHeader) then
                ShowItemAvailFromAsmHeader(AsmHeader,AvailabilityType)
              else
                if ShowItemAvailByBOMLevel(Item,FieldCaption("Shipment Date"),"Shipment Date",NewDate) then
                  Validate("Shipment Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromPurchLine(var PurchLine: Record "Purchase Line";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with PurchLine do begin
          TestField(Type,Type::Item);
          TestField("No.");
          Item.Reset;
          Item.Get("No.");
          FilterItem(Item,"Location Code","Variant Code","Expected Receipt Date");

          case AvailabilityType of
            Availabilitytype::Date:
              if ShowItemAvailByDate(Item,FieldCaption("Expected Receipt Date"),"Expected Receipt Date",NewDate) then
                Validate("Expected Receipt Date",NewDate);
            Availabilitytype::Variant:
              if ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode) then
                Validate("Variant Code",NewVariantCode);
            Availabilitytype::Location:
              if ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode) then
                Validate("Location Code",NewLocationCode);
            Availabilitytype::"Event":
              if ShowItemAvailByEvent(Item,FieldCaption("Expected Receipt Date"),"Expected Receipt Date",NewDate,false) then
                Validate("Expected Receipt Date",NewDate);
            Availabilitytype::BOM:
              if ShowItemAvailByBOMLevel(Item,FieldCaption("Expected Receipt Date"),"Expected Receipt Date",NewDate) then
                Validate("Expected Receipt Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromReqLine(var ReqLine: Record "Requisition Line";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with ReqLine do begin
          TestField(Type,Type::Item);
          TestField("No.");
          Item.Reset;
          Item.Get("No.");
          FilterItem(Item,"Location Code","Variant Code","Due Date");

          case AvailabilityType of
            Availabilitytype::Date:
              if ShowItemAvailByDate(Item,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
            Availabilitytype::Variant:
              if ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode) then
                Validate("Variant Code",NewVariantCode);
            Availabilitytype::Location:
              if ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode) then
                Validate("Location Code",NewLocationCode);
            Availabilitytype::"Event":
              begin
                Item.SetRange("Date Filter");

                ForecastName := '';
                FindCurrForecastName(ForecastName);

                if ShowItemAvailByEvent(Item,FieldCaption("Due Date"),"Due Date",NewDate,true) then
                  Validate("Due Date",NewDate);
              end;
            Availabilitytype::BOM:
              if ShowItemAvailByBOMLevel(Item,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromProdOrderLine(var ProdOrderLine: Record "Prod. Order Line";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with ProdOrderLine do begin
          TestField("Item No.");
          Item.Reset;
          Item.Get("Item No.");
          FilterItem(Item,"Location Code","Variant Code","Due Date");

          case AvailabilityType of
            Availabilitytype::Date:
              if ShowItemAvailByDate(Item,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
            Availabilitytype::Variant:
              if ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode) then
                Validate("Variant Code",NewVariantCode);
            Availabilitytype::Location:
              if ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode) then
                Validate("Location Code",NewLocationCode);
            Availabilitytype::"Event":
              if ShowItemAvailByEvent(Item,FieldCaption("Due Date"),"Due Date",NewDate,false) then
                Validate("Due Date",NewDate);
            Availabilitytype::BOM:
              if ShowCustomProdItemAvailByBOMLevel(ProdOrderLine,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromProdOrderComp(var ProdOrderComp: Record "Prod. Order Component";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with ProdOrderComp do begin
          TestField("Item No.");
          Item.Reset;
          Item.Get("Item No.");
          FilterItem(Item,"Location Code","Variant Code","Due Date");

          case AvailabilityType of
            Availabilitytype::Date:
              if ShowItemAvailByDate(Item,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
            Availabilitytype::Variant:
              if ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode) then
                Validate("Variant Code",NewVariantCode);
            Availabilitytype::Location:
              if ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode) then
                Validate("Location Code",NewLocationCode);
            Availabilitytype::"Event":
              if ShowItemAvailByEvent(Item,FieldCaption("Due Date"),"Due Date",NewDate,false) then
                Validate("Due Date",NewDate);
            Availabilitytype::BOM:
              if ShowItemAvailByBOMLevel(Item,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromTransLine(var TransLine: Record "Transfer Line";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with TransLine do begin
          TestField("Item No.");
          Item.Reset;
          Item.Get("Item No.");
          FilterItem(Item,"Transfer-from Code","Variant Code","Shipment Date");

          case AvailabilityType of
            Availabilitytype::Date:
              if ShowItemAvailByDate(Item,FieldCaption("Shipment Date"),"Shipment Date",NewDate) then
                Validate("Shipment Date",NewDate);
            Availabilitytype::Variant:
              if ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode) then
                Validate("Variant Code",NewVariantCode);
            Availabilitytype::Location:
              if ShowItemAvailByLoc(Item,FieldCaption("Transfer-from Code"),"Transfer-from Code",NewLocationCode) then
                Validate("Transfer-from Code",NewLocationCode);
            Availabilitytype::"Event":
              if ShowItemAvailByEvent(Item,FieldCaption("Shipment Date"),"Shipment Date",NewDate,false) then
                Validate("Shipment Date",NewDate);
            Availabilitytype::BOM:
              if ShowItemAvailByBOMLevel(Item,FieldCaption("Shipment Date"),"Shipment Date",NewDate) then
                Validate("Shipment Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromWhseActivLine(var WhseActivLine: Record "Warehouse Activity Line";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with WhseActivLine do begin
          TestField("Item No.");
          Item.Reset;
          Item.Get("Item No.");
          FilterItem(Item,"Location Code","Variant Code","Due Date");

          case AvailabilityType of
            Availabilitytype::Date:
              ShowItemAvailByDate(Item,FieldCaption("Due Date"),"Due Date",NewDate);
            Availabilitytype::Variant:
              ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode);
            Availabilitytype::Location:
              ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode);
            Availabilitytype::"Event":
              ShowItemAvailByEvent(Item,FieldCaption("Due Date"),"Due Date",NewDate,false);
            Availabilitytype::BOM:
              ShowItemAvailByBOMLevel(Item,FieldCaption("Due Date"),"Due Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromServLine(var ServLine: Record "Service Line";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        ServHeader: Record "Service Header";
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with ServLine do begin
          ServHeader.Get("Document Type","Document No.");
          TestField(Type,Type::Item);
          TestField("No.");
          Item.Reset;
          Item.Get("No.");
          FilterItem(Item,"Location Code","Variant Code",ServHeader."Response Date");

          case AvailabilityType of
            Availabilitytype::Date:
              ShowItemAvailByDate(Item,ServHeader.FieldCaption("Response Date"),ServHeader."Response Date",NewDate);
            Availabilitytype::Variant:
              if ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode) then
                Validate("Variant Code",NewVariantCode);
            Availabilitytype::Location:
              if ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode) then
                Validate("Location Code",NewLocationCode);
            Availabilitytype::"Event":
              ShowItemAvailByEvent(Item,ServHeader.FieldCaption("Response Date"),ServHeader."Response Date",NewDate,false);
            Availabilitytype::BOM:
              ShowItemAvailByBOMLevel(Item,ServHeader.FieldCaption("Response Date"),ServHeader."Response Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromWhseRcptLine(var WhseRcptLine: Record "Warehouse Receipt Line";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with WhseRcptLine do begin
          TestField("Item No.");
          Item.Reset;
          Item.Get("Item No.");
          FilterItem(Item,"Location Code","Variant Code","Due Date");

          case AvailabilityType of
            Availabilitytype::Date:
              ShowItemAvailByDate(Item,FieldCaption("Due Date"),"Due Date",NewDate);
            Availabilitytype::Variant:
              ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode);
            Availabilitytype::Location:
              ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode);
            Availabilitytype::"Event":
              ShowItemAvailByEvent(Item,FieldCaption("Due Date"),"Due Date",NewDate,false);
            Availabilitytype::BOM:
              ShowItemAvailByBOMLevel(Item,FieldCaption("Due Date"),"Due Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromItemJnlLine(var ItemJnlLine: Record "Item Journal Line";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with ItemJnlLine do begin
          TestField("Item No.");
          Item.Reset;
          Item.Get("Item No.");
          FilterItem(Item,"Location Code","Variant Code","Posting Date");

          case AvailabilityType of
            Availabilitytype::Date:
              if ShowItemAvailByDate(Item,FieldCaption("Posting Date"),"Posting Date",NewDate) then
                Validate("Posting Date",NewDate);
            Availabilitytype::Variant:
              if ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode) then
                Validate("Variant Code",NewVariantCode);
            Availabilitytype::Location:
              if ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode) then
                Validate("Location Code",NewLocationCode);
            Availabilitytype::"Event":
              if ShowItemAvailByEvent(Item,FieldCaption("Posting Date"),"Posting Date",NewDate,false) then
                Validate("Posting Date",NewDate);
            Availabilitytype::BOM:
              if ShowItemAvailByBOMLevel(Item,FieldCaption("Posting Date"),"Posting Date",NewDate) then
                Validate("Posting Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromAsmHeader(var AsmHeader: Record "Assembly Header";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with AsmHeader do begin
          TestField("Item No.");
          Item.Reset;
          Item.Get("Item No.");
          FilterItem(Item,"Location Code","Variant Code","Due Date");

          case AvailabilityType of
            Availabilitytype::Date:
              if ShowItemAvailByDate(Item,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
            Availabilitytype::Variant:
              if ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode) then
                Validate("Variant Code",NewVariantCode);
            Availabilitytype::Location:
              if ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode) then
                Validate("Location Code",NewLocationCode);
            Availabilitytype::"Event":
              if ShowItemAvailByEvent(Item,FieldCaption("Due Date"),"Due Date",NewDate,false) then
                Validate("Due Date",NewDate);
            Availabilitytype::BOM:
              if ShowCustomAsmItemAvailByBOMLevel(AsmHeader,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromAsmLine(var AsmLine: Record "Assembly Line";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with AsmLine do begin
          TestField(Type,Type::Item);
          TestField("No.");
          Item.Reset;
          Item.Get("No.");
          FilterItem(Item,"Location Code","Variant Code","Due Date");

          case AvailabilityType of
            Availabilitytype::Date:
              if ShowItemAvailByDate(Item,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
            Availabilitytype::Variant:
              if ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode) then
                Validate("Variant Code",NewVariantCode);
            Availabilitytype::Location:
              if ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode) then
                Validate("Location Code",NewLocationCode);
            Availabilitytype::"Event":
              if ShowItemAvailByEvent(Item,FieldCaption("Due Date"),"Due Date",NewDate,false) then
                Validate("Due Date",NewDate);
            Availabilitytype::BOM:
              if ShowItemAvailByBOMLevel(Item,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
          end;
        end;
    end;


    procedure ShowItemAvailFromPlanningComp(var PlanningComp: Record "Planning Component";AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
    begin
        with PlanningComp do begin
          TestField("Item No.");
          Item.Reset;
          Item.Get("Item No.");
          FilterItem(Item,"Location Code","Variant Code","Due Date");

          case AvailabilityType of
            Availabilitytype::Date:
              if ShowItemAvailByDate(Item,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
            Availabilitytype::Variant:
              if ShowItemAvailVariant(Item,FieldCaption("Variant Code"),"Variant Code",NewVariantCode) then
                Validate("Variant Code",NewVariantCode);
            Availabilitytype::Location:
              if ShowItemAvailByLoc(Item,FieldCaption("Location Code"),"Location Code",NewLocationCode) then
                Validate("Location Code",NewLocationCode);
            Availabilitytype::"Event":
              begin
                ForecastName := '';
                FindCurrForecastName(ForecastName);

                if ShowItemAvailByEvent(Item,FieldCaption("Due Date"),"Due Date",NewDate,true) then
                  Validate("Due Date",NewDate);
              end;
            Availabilitytype::BOM:
              if ShowItemAvailByBOMLevel(Item,FieldCaption("Due Date"),"Due Date",NewDate) then
                Validate("Due Date",NewDate);
          end;
        end;
    end;

    local procedure ShowItemAvailByEvent(var Item: Record Item;FieldCaption: Text[80];OldDate: Date;var NewDate: Date;IncludeForecast: Boolean): Boolean
    var
        ItemAvailByEvent: Page "Item Availability by Event";
    begin
        if FieldCaption <> '' then
          ItemAvailByEvent.LookupMode(true);
        ItemAvailByEvent.SetItem(Item);
        if IncludeForecast then begin
          ItemAvailByEvent.SetIncludePlan(true);
          if ForecastName <> '' then
            ItemAvailByEvent.SetForecastName(ForecastName);
        end;
        if ItemAvailByEvent.RunModal = Action::LookupOK then begin
          NewDate := ItemAvailByEvent.GetSelectedDate;
          if (NewDate <> 0D) and (NewDate <> OldDate) then
            if Confirm(Text012,true,FieldCaption,OldDate,NewDate) then
              exit(true);
        end;
    end;

    local procedure ShowItemAvailByLoc(var Item: Record Item;FieldCaption: Text[80];OldLocationCode: Code[20];var NewLocationCode: Code[20]): Boolean
    var
        ItemAvailByLoc: Page "Item Availability by Location";
    begin
        Item.SetRange("Location Filter");
        if FieldCaption <> '' then
          ItemAvailByLoc.LookupMode(true);
        ItemAvailByLoc.SetRecord(Item);
        ItemAvailByLoc.SetTableview(Item);
        if ItemAvailByLoc.RunModal = Action::LookupOK then begin
          NewLocationCode := ItemAvailByLoc.GetLastLocation;
          if OldLocationCode <> NewLocationCode then
            if Confirm(Text012,true,FieldCaption,OldLocationCode,NewLocationCode) then
              exit(true);
        end;
    end;

    local procedure ShowItemAvailByDate(var Item: Record Item;FieldCaption: Text[80];OldDate: Date;var NewDate: Date): Boolean
    var
        ItemAvailByPeriods: Page "Item Availability by Periods";
    begin
        Item.SetRange("Date Filter");
        if FieldCaption <> '' then
          ItemAvailByPeriods.LookupMode(true);
        ItemAvailByPeriods.SetRecord(Item);
        ItemAvailByPeriods.SetTableview(Item);
        if ItemAvailByPeriods.RunModal = Action::LookupOK then begin
          NewDate := ItemAvailByPeriods.GetLastDate;
          if OldDate <> NewDate then
            if Confirm(Text012,true,FieldCaption,OldDate,NewDate) then
              exit(true);
        end;
    end;

    local procedure ShowItemAvailVariant(var Item: Record Item;FieldCaption: Text[80];OldVariant: Code[20];var NewVariant: Code[20]): Boolean
    var
        ItemAvailByVariant: Page "Item Availability by Variant";
    begin
        Item.SetRange("Variant Filter");
        if FieldCaption <> '' then
          ItemAvailByVariant.LookupMode(true);
        ItemAvailByVariant.SetRecord(Item);
        ItemAvailByVariant.SetTableview(Item);
        if ItemAvailByVariant.RunModal = Action::LookupOK then begin
          NewVariant := ItemAvailByVariant.GetLastVariant;
          if OldVariant <> NewVariant then
            if Confirm(Text012,true,FieldCaption,OldVariant,NewVariant) then
              exit(true);
        end;
    end;

    local procedure ShowItemAvailByBOMLevel(var Item: Record Item;FieldCaption: Text[80];OldDate: Date;var NewDate: Date): Boolean
    begin
        Clear(ItemAvailByBOMLevel);
        Item.SetRange("Date Filter");
        ItemAvailByBOMLevel.InitItem(Item);
        ItemAvailByBOMLevel.InitDate(OldDate);
        exit(ShowBOMLevelAbleToMake(FieldCaption,OldDate,NewDate));
    end;

    local procedure ShowCustomAsmItemAvailByBOMLevel(var AsmHeader: Record "Assembly Header";FieldCaption: Text[80];OldDate: Date;var NewDate: Date): Boolean
    begin
        Clear(ItemAvailByBOMLevel);
        ItemAvailByBOMLevel.InitAsmOrder(AsmHeader);
        ItemAvailByBOMLevel.InitDate(OldDate);
        exit(ShowBOMLevelAbleToMake(FieldCaption,OldDate,NewDate));
    end;

    local procedure ShowCustomProdItemAvailByBOMLevel(var ProdOrderLine: Record "Prod. Order Line";FieldCaption: Text[80];OldDate: Date;var NewDate: Date): Boolean
    begin
        Clear(ItemAvailByBOMLevel);
        ItemAvailByBOMLevel.InitProdOrder(ProdOrderLine);
        ItemAvailByBOMLevel.InitDate(OldDate);
        exit(ShowBOMLevelAbleToMake(FieldCaption,OldDate,NewDate));
    end;

    local procedure ShowBOMLevelAbleToMake(FieldCaption: Text[80];OldDate: Date;var NewDate: Date): Boolean
    begin
        if FieldCaption <> '' then
          ItemAvailByBOMLevel.LookupMode(true);
        if ItemAvailByBOMLevel.RunModal = Action::LookupOK then begin
          NewDate := ItemAvailByBOMLevel.GetSelectedDate;
          if OldDate <> NewDate then
            if Confirm(Text012,true,FieldCaption,OldDate,NewDate) then
              exit(true);
        end;
    end;

    local procedure FilterItem(var Item: Record Item;LocationCode: Code[20];VariantCode: Code[20];Date: Date)
    begin
        Item.SetRange("No.",Item."No.");
        Item.SetRange("Date Filter",0D,Date);
        Item.SetRange("Variant Filter",VariantCode);
        Item.SetRange("Location Filter",LocationCode);
    end;


    procedure ByEvent(): Integer
    begin
        exit(Availabilitytype::"Event");
    end;


    procedure ByLocation(): Integer
    begin
        exit(Availabilitytype::Location);
    end;


    procedure ByVariant(): Integer
    begin
        exit(Availabilitytype::Variant);
    end;


    procedure ByPeriod(): Integer
    begin
        exit(Availabilitytype::Date);
    end;


    procedure ByBOM(): Integer
    begin
        exit(Availabilitytype::BOM);
    end;
}

