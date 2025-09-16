#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5701 "Item Subst."
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'This substitute item has a different sale unit of measure.';
        Item: Record Item;
        ItemSubstitution: Record "Item Substitution";
        TempItemSubstitution: Record "Item Substitution" temporary;
        SalesHeader: Record "Sales Header";
        NonStockItem: Record "Nonstock Item";
        TempSalesLine: Record "Sales Line" temporary;
        ServInvLine: Record "Service Line";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        CompanyInfo: Record "Company Information";
        NonstockItemMgt: Codeunit "Catalog Item Management";
        AvailToPromise: Codeunit "Available to Promise";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        SaveDropShip: Boolean;
        SetupDataIsPresent: Boolean;
        GrossReq: Decimal;
        SchedRcpt: Decimal;
        SaveQty: Decimal;
        SaveItemNo: Code[20];
        SaveVariantCode: Code[10];
        SaveLocation: Code[10];
        OldSalesUOM: Code[10];
        Text001: label 'An Item Substitution with the specified variant does not exist for Item No. ''%1''.';
        Text002: label 'An Item Substitution does not exist for Item No. ''%1''';


    procedure ItemSubstGet(var SalesLine: Record "Sales Line")
    begin
        TempSalesLine := SalesLine;
        if (TempSalesLine.Type <> TempSalesLine.Type::Item) or
           (TempSalesLine."Document Type" in
            [TempSalesLine."document type"::"Return Order",TempSalesLine."document type"::"Credit Memo"])
        then
          exit;

        SaveItemNo := TempSalesLine."No.";
        SaveVariantCode := TempSalesLine."Variant Code";

        Item.Get(TempSalesLine."No.");
        Item.SetFilter("Location Filter",TempSalesLine."Location Code");
        Item.SetFilter("Variant Filter",TempSalesLine."Variant Code");
        Item.SetRange("Date Filter",0D,TempSalesLine."Shipment Date");
        Item.CalcFields(Inventory);
        Item.CalcFields("Qty. on Sales Order");
        Item.CalcFields("Qty. on Service Order");
        OldSalesUOM := Item."Sales Unit of Measure";

        ItemSubstitution.Reset;
        ItemSubstitution.SetRange(Type,ItemSubstitution.Type::Item);
        ItemSubstitution.SetRange("No.",TempSalesLine."No.");
        ItemSubstitution.SetRange("Variant Code",TempSalesLine."Variant Code");
        ItemSubstitution.SetRange("Location Filter",TempSalesLine."Location Code");
        if ItemSubstitution.Find('-') then begin
          CalcCustPrice;
          TempItemSubstitution.Reset;
          TempItemSubstitution.SetRange("No.",TempSalesLine."No.");
          TempItemSubstitution.SetRange("Variant Code",TempSalesLine."Variant Code");
          TempItemSubstitution.SetRange("Location Filter",TempSalesLine."Location Code");
          if Page.RunModal(Page::"Item Substitution Entries",TempItemSubstitution) =
             Action::LookupOK
          then begin
            if TempItemSubstitution."Substitute Type" =
               TempItemSubstitution."substitute type"::"Nonstock Item"
            then begin
              NonStockItem.Get(TempItemSubstitution."Substitute No.");
              if NonStockItem."Item No." = '' then begin
                NonstockItemMgt.CreateItemFromNonstock(NonStockItem);
                NonStockItem.Get(TempItemSubstitution."Substitute No.");
              end;
              TempItemSubstitution."Substitute No." := NonStockItem."Item No."
            end;
            TempSalesLine."No." := TempItemSubstitution."Substitute No.";
            TempSalesLine."Variant Code" := TempItemSubstitution."Substitute Variant Code";
            SaveQty := TempSalesLine.Quantity;
            SaveLocation := TempSalesLine."Location Code";
            SaveDropShip := TempSalesLine."Drop Shipment";
            TempSalesLine.Quantity := 0;
            TempSalesLine.Validate("No.",TempItemSubstitution."Substitute No.");
            TempSalesLine.Validate("Variant Code",TempItemSubstitution."Substitute Variant Code");
            TempSalesLine."Originally Ordered No." := SaveItemNo;
            TempSalesLine."Originally Ordered Var. Code" := SaveVariantCode;
            TempSalesLine."Location Code" := SaveLocation;
            TempSalesLine."Drop Shipment" := SaveDropShip;
            TempSalesLine.Validate(Quantity,SaveQty);
            TempSalesLine.Validate("Unit of Measure Code",OldSalesUOM);
            Commit;
            if ItemCheckAvail.SalesLineCheck(TempSalesLine) then
              TempSalesLine := SalesLine;
          end;
        end else
          Error(Text001,TempSalesLine."No.");

        SalesLine := TempSalesLine;
    end;

    local procedure CalcCustPrice()
    begin
        TempItemSubstitution.Reset;
        TempItemSubstitution.DeleteAll;
        SalesHeader.Get(TempSalesLine."Document Type",TempSalesLine."Document No.");
        if ItemSubstitution.Find('-') then
          repeat
            TempItemSubstitution."No." := ItemSubstitution."No.";
            TempItemSubstitution."Variant Code" := ItemSubstitution."Variant Code";
            TempItemSubstitution."Substitute No." := ItemSubstitution."Substitute No.";
            TempItemSubstitution."Substitute Variant Code" := ItemSubstitution."Substitute Variant Code";
            TempItemSubstitution.Description := ItemSubstitution.Description;
            TempItemSubstitution.Interchangeable := ItemSubstitution.Interchangeable;
            TempItemSubstitution."Location Filter" := ItemSubstitution."Location Filter";
            TempItemSubstitution.Condition := ItemSubstitution.Condition;
            TempItemSubstitution."Shipment Date" := TempSalesLine."Shipment Date";
            if ItemSubstitution."Substitute Type" = ItemSubstitution."substitute type"::Item then begin
              Item.Get(ItemSubstitution."Substitute No.");
              if not SetupDataIsPresent then
                GetSetupData;
              TempItemSubstitution."Quantity Avail. on Shpt. Date" :=
                AvailToPromise.QtyAvailabletoPromise(
                  Item,GrossReq,SchedRcpt,
                  Item.GetRangemax("Date Filter"),CompanyInfo."Check-Avail. Time Bucket",
                  CompanyInfo."Check-Avail. Period Calc.");
              Item.CalcFields(Inventory);
              TempItemSubstitution.Inventory := Item.Inventory;
            end else begin
              TempItemSubstitution."Substitute Type" := TempItemSubstitution."substitute type"::"Nonstock Item";
              TempItemSubstitution."Quantity Avail. on Shpt. Date" := 0;
              TempItemSubstitution.Inventory := 0;
            end;
            TempItemSubstitution.Insert;
          until ItemSubstitution.Next = 0;
    end;

    local procedure AssemblyCalcCustPrice(AssemblyLine: Record "Assembly Line")
    var
        AssemblyHeader: Record "Assembly Header";
    begin
        TempItemSubstitution.Reset;
        TempItemSubstitution.DeleteAll;
        AssemblyHeader.Get(AssemblyLine.Type,AssemblyLine."Document No.");
        if ItemSubstitution.Find('-') then
          repeat
            TempItemSubstitution."No." := ItemSubstitution."No.";
            TempItemSubstitution."Variant Code" := ItemSubstitution."Variant Code";
            TempItemSubstitution."Substitute No." := ItemSubstitution."Substitute No.";
            TempItemSubstitution."Substitute Variant Code" := ItemSubstitution."Substitute Variant Code";
            TempItemSubstitution.Description := ItemSubstitution.Description;
            TempItemSubstitution.Interchangeable := ItemSubstitution.Interchangeable;
            TempItemSubstitution."Location Filter" := ItemSubstitution."Location Filter";
            TempItemSubstitution.Condition := ItemSubstitution.Condition;
            TempItemSubstitution."Shipment Date" := TempSalesLine."Shipment Date";
            if ItemSubstitution."Substitute Type" = ItemSubstitution."substitute type"::Item then begin
              Item.Get(ItemSubstitution."Substitute No.");
              if not SetupDataIsPresent then
                GetSetupData;
              TempItemSubstitution."Quantity Avail. on Shpt. Date" :=
                AvailToPromise.QtyAvailabletoPromise(
                  Item,GrossReq,SchedRcpt,
                  Item.GetRangemax("Date Filter"),CompanyInfo."Check-Avail. Time Bucket",
                  CompanyInfo."Check-Avail. Period Calc.");
              Item.CalcFields(Inventory);
              TempItemSubstitution.Inventory := Item.Inventory;
            end else begin
              TempItemSubstitution."Substitute Type" := TempItemSubstitution."substitute type"::"Nonstock Item";
              TempItemSubstitution."Quantity Avail. on Shpt. Date" := 0;
              TempItemSubstitution.Inventory := 0;
            end;
            TempItemSubstitution.Insert;
          until ItemSubstitution.Next = 0;
    end;


    procedure ItemServiceSubstGet(var ServInvLine2: Record "Service Line")
    begin
        ServInvLine := ServInvLine2;
        if ServInvLine.Type <> ServInvLine.Type::Item then
          exit;

        SaveItemNo := ServInvLine."No.";
        SaveVariantCode := ServInvLine."Variant Code";
        Item.Get(ServInvLine."No.");
        Item.SetFilter("Location Filter",ServInvLine."Location Code");
        Item.SetFilter("Variant Filter",ServInvLine."Variant Code");
        Item.SetRange("Date Filter",0D,ServInvLine."Order Date");
        Item.CalcFields(Inventory);
        Item.CalcFields("Qty. on Sales Order");
        Item.CalcFields("Qty. on Service Order");
        OldSalesUOM := Item."Sales Unit of Measure";

        ItemSubstitution.Reset;
        ItemSubstitution.SetRange("No.",ServInvLine."No.");
        ItemSubstitution.SetRange("Variant Code",ServInvLine."Variant Code");
        ItemSubstitution.SetRange("Location Filter",ServInvLine."Location Code");
        if ItemSubstitution.Find('-') then begin
          TempItemSubstitution.DeleteAll;
          InsertInSubstServiceList(ServInvLine."No.",ItemSubstitution,1);
          TempItemSubstitution.Reset;
          if TempItemSubstitution.Find('-') then;
          if Page.RunModal(Page::"Service Item Substitutions",TempItemSubstitution) =
             Action::LookupOK
          then begin
            if TempItemSubstitution."Substitute Type" =
               TempItemSubstitution."substitute type"::"Nonstock Item"
            then begin
              NonStockItem.Get(TempItemSubstitution."Substitute No.");
              if NonStockItem."Item No." <> '' then
                TempItemSubstitution."Substitute No." := NonStockItem."Item No."
              else begin
                ServInvLine."No." := TempItemSubstitution."Substitute No.";
                ServInvLine."Variant Code" := TempItemSubstitution."Substitute Variant Code";
                NonstockItemMgt.NonStockFSM(ServInvLine);
                TempItemSubstitution."Substitute No." := ServInvLine."No.";
              end;
            end;
            ServInvLine."No." := TempItemSubstitution."Substitute No.";
            ServInvLine."Variant Code" := TempItemSubstitution."Substitute Variant Code";
            SaveQty := ServInvLine.Quantity;
            SaveLocation := ServInvLine."Location Code";
            ServInvLine.Quantity := 0;
            ServInvLine.Validate("No.",TempItemSubstitution."Substitute No.");
            ServInvLine.Validate("Variant Code",TempItemSubstitution."Substitute Variant Code");
            ServInvLine."Location Code" := SaveLocation;
            ServInvLine.Validate(Quantity,SaveQty);
            ServInvLine.Validate("Unit of Measure Code",OldSalesUOM);
            Commit;
            if ItemCheckAvail.ServiceInvLineCheck(ServInvLine) then
              ServInvLine := ServInvLine2;
            if Item.Get(ServInvLine."No.") and
               (Item."Sales Unit of Measure" <> OldSalesUOM)
            then
              Message(Text000);
          end;
        end else
          Error(Text001,ServInvLine."No.");

        ServInvLine2 := ServInvLine;
    end;

    local procedure InsertInSubstServiceList(OrgNo: Code[20];var ItemSubstitution3: Record "Item Substitution";RelationsLevel: Integer)
    var
        ItemSubstitution: Record "Item Substitution";
        ItemSubstitution2: Record "Item Substitution";
        NonStockItem: Record "Nonstock Item";
        RelatLevel: Integer;
    begin
        ItemSubstitution.Copy(ItemSubstitution3);
        RelatLevel := RelationsLevel;

        if ItemSubstitution.Find('-') then
          repeat
            Clear(TempItemSubstitution);
            TempItemSubstitution.Type := ItemSubstitution.Type;
            TempItemSubstitution."No." := ItemSubstitution."No.";
            TempItemSubstitution."Variant Code" := ItemSubstitution."Variant Code";
            TempItemSubstitution."Substitute Type" := ItemSubstitution."Substitute Type";
            TempItemSubstitution."Substitute No." := ItemSubstitution."Substitute No.";
            TempItemSubstitution."Substitute Variant Code" := ItemSubstitution."Substitute Variant Code";
            TempItemSubstitution.Description := ItemSubstitution.Description;
            TempItemSubstitution.Interchangeable := ItemSubstitution.Interchangeable;
            TempItemSubstitution."Location Filter" := ItemSubstitution."Location Filter";
            TempItemSubstitution."Relations Level" := RelatLevel;

            if TempItemSubstitution."Substitute Type" = TempItemSubstitution.Type::Item then begin
              Item.Get(ItemSubstitution."Substitute No.");
              if not SetupDataIsPresent then
                GetSetupData;
              TempItemSubstitution."Quantity Avail. on Shpt. Date" :=
                AvailToPromise.QtyAvailabletoPromise(
                  Item,GrossReq,SchedRcpt,
                  Item.GetRangemax("Date Filter"),2,
                  CompanyInfo."Check-Avail. Period Calc.");
              Item.CalcFields(Inventory);
              TempItemSubstitution.Inventory := Item.Inventory;
            end;

            if TempItemSubstitution.Insert and
               (ItemSubstitution."Substitute No." <> '')
            then begin
              ItemSubstitution2.SetRange(Type,ItemSubstitution.Type);
              ItemSubstitution2.SetRange("No.",ItemSubstitution."Substitute No.");
              ItemSubstitution2.SetFilter("Substitute No.",'<>%1&<>%2',ItemSubstitution."No.",OrgNo);
              ItemSubstitution.Copyfilter("Variant Code",ItemSubstitution2."Variant Code");
              ItemSubstitution.Copyfilter("Location Filter",ItemSubstitution2."Location Filter");
              if ItemSubstitution2.FindFirst then
                InsertInSubstServiceList(OrgNo,ItemSubstitution2,(RelatLevel + 1));
            end else begin
              TempItemSubstitution.Find;
              if RelatLevel < TempItemSubstitution."Relations Level" then begin
                TempItemSubstitution."Relations Level" := RelatLevel;
                TempItemSubstitution.Modify;
              end;
            end;

            if (ItemSubstitution."Substitute Type" = ItemSubstitution."substitute type"::"Nonstock Item") and
               (ItemSubstitution."Substitute No." <> '') and
               NonStockItem.Get(ItemSubstitution."Substitute No.") and
               (NonStockItem."Item No." <> '')
            then begin
              Clear(TempItemSubstitution);
              TempItemSubstitution.Type := ItemSubstitution.Type;
              TempItemSubstitution."No." := ItemSubstitution."No.";
              TempItemSubstitution."Variant Code" := ItemSubstitution."Variant Code";
              TempItemSubstitution."Substitute Type" := TempItemSubstitution."substitute type"::Item;
              TempItemSubstitution."Substitute No." := NonStockItem."Item No.";
              TempItemSubstitution."Substitute Variant Code" := '';
              TempItemSubstitution.Description := ItemSubstitution.Description;
              TempItemSubstitution.Interchangeable := ItemSubstitution.Interchangeable;
              TempItemSubstitution."Location Filter" := ItemSubstitution."Location Filter";
              TempItemSubstitution."Relations Level" := RelatLevel;
              if TempItemSubstitution.Insert then begin
                ItemSubstitution2.SetRange(Type,ItemSubstitution2.Type::"Nonstock Item");
                ItemSubstitution2.SetRange("No.",NonStockItem."Item No.");
                ItemSubstitution2.SetFilter("Substitute No.",'<>%1&<>%2',NonStockItem."Item No.",OrgNo);
                ItemSubstitution.Copyfilter("Variant Code",ItemSubstitution2."Variant Code");
                ItemSubstitution.Copyfilter("Location Filter",ItemSubstitution2."Location Filter");
                if ItemSubstitution2.FindFirst then
                  InsertInSubstServiceList(OrgNo,ItemSubstitution2,(RelatLevel + 1));
              end else begin
                TempItemSubstitution.Find;
                if RelatLevel < TempItemSubstitution."Relations Level" then begin
                  TempItemSubstitution."Relations Level" := RelatLevel;
                  TempItemSubstitution.Modify;
                end;
              end;
            end;
          until ItemSubstitution.Next = 0;
    end;

    local procedure GetSetupData()
    begin
        CompanyInfo.Get;
        SetupDataIsPresent := true;
    end;


    procedure GetCompSubst(var ProdOrderComp: Record "Prod. Order Component")
    begin
        if not PrepareSubstList(
             ProdOrderComp."Item No.",
             ProdOrderComp."Variant Code",
             ProdOrderComp."Location Code",
             ProdOrderComp."Due Date",
             true)
        then
          ErrorMessage(ProdOrderComp."Item No.",ProdOrderComp."Variant Code");

        TempItemSubstitution.Reset;
        TempItemSubstitution.SetRange("Variant Code",ProdOrderComp."Variant Code");
        TempItemSubstitution.SetRange("Location Filter",ProdOrderComp."Location Code");
        if TempItemSubstitution.Find('-') then;
        if Page.RunModal(Page::"Item Substitution Entries",TempItemSubstitution) = Action::LookupOK then
          UpdateComponent(ProdOrderComp,TempItemSubstitution."Substitute No.",TempItemSubstitution."Substitute Variant Code");
    end;


    procedure UpdateComponent(var ProdOrderComp: Record "Prod. Order Component";SubstItemNo: Code[20];SubstVariantCode: Code[10])
    var
        TempProdOrderComp: Record "Prod. Order Component" temporary;
    begin
        TempProdOrderComp := ProdOrderComp;

        with TempProdOrderComp do begin
          SaveQty := "Quantity per";

          "Item No." := SubstItemNo;
          "Variant Code" := SubstVariantCode;
          "Location Code" := ProdOrderComp."Location Code";
          "Quantity per" := 0;
          Validate("Item No.");
          Validate("Variant Code");

          "Original Item No." := ProdOrderComp."Item No.";
          "Original Variant Code" := ProdOrderComp."Variant Code";

          if ProdOrderComp."Qty. per Unit of Measure" <> 1 then begin
            if ItemUnitOfMeasure.Get(Item."No.",ProdOrderComp."Unit of Measure Code") and
               (ItemUnitOfMeasure."Qty. per Unit of Measure" = ProdOrderComp."Qty. per Unit of Measure")
            then
              Validate("Unit of Measure Code",ProdOrderComp."Unit of Measure Code")
            else
              SaveQty := ROUND(ProdOrderComp."Quantity per" * ProdOrderComp."Qty. per Unit of Measure",0.00001);
          end;
          Validate("Quantity per",SaveQty);
        end;

        ProdOrderComp := TempProdOrderComp;
    end;


    procedure PrepareSubstList(ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];DemandDate: Date;CalcATP: Boolean): Boolean
    begin
        Item.Get(ItemNo);
        Item.SetFilter("Location Filter",LocationCode);
        Item.SetFilter("Variant Filter",VariantCode);
        Item.SetRange("Date Filter",0D,DemandDate);

        ItemSubstitution.Reset;
        ItemSubstitution.SetRange(Type,ItemSubstitution.Type::Item);
        ItemSubstitution.SetRange("No.",ItemNo);
        ItemSubstitution.SetRange("Variant Code",VariantCode);
        ItemSubstitution.SetRange("Location Filter",LocationCode);
        if ItemSubstitution.Find('-') then begin
          TempItemSubstitution.DeleteAll;
          CreateSubstList(ItemNo,ItemSubstitution,1,DemandDate,CalcATP);
          exit(true);
        end;

        exit(false);
    end;

    local procedure CreateSubstList(OrgNo: Code[20];var ItemSubstitution3: Record "Item Substitution";RelationsLevel: Integer;DemandDate: Date;CalcATP: Boolean)
    var
        ItemSubstitution: Record "Item Substitution";
        ItemSubstitution2: Record "Item Substitution";
        RelationsLevel2: Integer;
        ODF: DateFormula;
    begin
        ItemSubstitution.Copy(ItemSubstitution3);
        RelationsLevel2 := RelationsLevel;

        if ItemSubstitution.Find('-') then
          repeat
            Clear(TempItemSubstitution);
            TempItemSubstitution.Type := ItemSubstitution.Type;
            TempItemSubstitution."No." := ItemSubstitution."No.";
            TempItemSubstitution."Variant Code" := ItemSubstitution."Variant Code";
            TempItemSubstitution."Substitute Type" := ItemSubstitution."Substitute Type";
            TempItemSubstitution."Substitute No." := ItemSubstitution."Substitute No.";
            TempItemSubstitution."Substitute Variant Code" := ItemSubstitution."Substitute Variant Code";
            TempItemSubstitution.Description := ItemSubstitution.Description;
            TempItemSubstitution.Interchangeable := ItemSubstitution.Interchangeable;
            TempItemSubstitution."Location Filter" := ItemSubstitution."Location Filter";
            TempItemSubstitution."Relations Level" := RelationsLevel2;
            TempItemSubstitution."Shipment Date" := DemandDate;

            if CalcATP then begin
              Item.Get(ItemSubstitution."Substitute No.");
              TempItemSubstitution."Quantity Avail. on Shpt. Date" :=
                AvailToPromise.QtyAvailabletoPromise(
                  Item,GrossReq,SchedRcpt,
                  Item.GetRangemax("Date Filter"),2,ODF);
              Item.CalcFields(Inventory);
              TempItemSubstitution.Inventory := Item.Inventory;
            end;

            if IsSubstitutionInserted(TempItemSubstitution,ItemSubstitution) then begin
              ItemSubstitution2.SetRange(Type,ItemSubstitution.Type);
              ItemSubstitution2.SetRange("No.",ItemSubstitution."Substitute No.");
              ItemSubstitution2.SetFilter("Substitute No.",'<>%1&<>%2',ItemSubstitution."No.",OrgNo);
              ItemSubstitution.Copyfilter("Variant Code",ItemSubstitution2."Variant Code");
              ItemSubstitution.Copyfilter("Location Filter",ItemSubstitution2."Location Filter");
              if ItemSubstitution2.FindFirst then
                CreateSubstList(OrgNo,ItemSubstitution2,RelationsLevel2 + 1,DemandDate,CalcATP);
            end else begin
              TempItemSubstitution.Reset;
              if TempItemSubstitution.Find then
                if RelationsLevel2 < TempItemSubstitution."Relations Level" then begin
                  TempItemSubstitution."Relations Level" := RelationsLevel2;
                  TempItemSubstitution.Modify;
                end;
            end;
          until ItemSubstitution.Next = 0;
    end;


    procedure GetTempItemSubstList(var TempItemSubstitutionList: Record "Item Substitution" temporary)
    begin
        TempItemSubstitutionList.DeleteAll;

        TempItemSubstitution.Reset;
        if TempItemSubstitution.Find('-') then
          repeat
            TempItemSubstitutionList := TempItemSubstitution;
            TempItemSubstitutionList.Insert;
          until TempItemSubstitution.Next = 0;
    end;


    procedure ErrorMessage(ItemNo: Code[20];VariantCode: Code[10])
    begin
        if VariantCode <> '' then
          Error(Text001,ItemNo);

        Error(Text002,ItemNo);
    end;


    procedure ItemAssemblySubstGet(var AssemblyLine: Record "Assembly Line")
    var
        TempAssemblyLine: Record "Assembly Line" temporary;
    begin
        TempAssemblyLine := AssemblyLine;
        if TempAssemblyLine.Type <> TempAssemblyLine.Type::Item then
          exit;

        SaveItemNo := TempAssemblyLine."No.";
        SaveVariantCode := TempAssemblyLine."Variant Code";

        Item.Get(TempAssemblyLine."No.");
        Item.SetFilter("Location Filter",TempAssemblyLine."Location Code");
        Item.SetFilter("Variant Filter",TempAssemblyLine."Variant Code");
        Item.SetRange("Date Filter",0D,TempAssemblyLine."Due Date");
        Item.CalcFields(Inventory);
        Item.CalcFields("Qty. on Sales Order");
        Item.CalcFields("Qty. on Service Order");
        OldSalesUOM := Item."Sales Unit of Measure";

        ItemSubstitution.Reset;
        ItemSubstitution.SetRange(Type,ItemSubstitution.Type::Item);
        ItemSubstitution.SetRange("No.",TempAssemblyLine."No.");
        ItemSubstitution.SetRange("Variant Code",TempAssemblyLine."Variant Code");
        ItemSubstitution.SetRange("Location Filter",TempAssemblyLine."Location Code");
        if ItemSubstitution.Find('-') then begin
          AssemblyCalcCustPrice(TempAssemblyLine);
          TempItemSubstitution.Reset;
          TempItemSubstitution.SetRange(Type,TempItemSubstitution.Type::Item);
          TempItemSubstitution.SetRange("No.",TempAssemblyLine."No.");
          TempItemSubstitution.SetRange("Variant Code",TempAssemblyLine."Variant Code");
          TempItemSubstitution.SetRange("Location Filter",TempAssemblyLine."Location Code");
          if Page.RunModal(Page::"Item Substitution Entries",TempItemSubstitution) =
             Action::LookupOK
          then begin
            TempAssemblyLine."No." := TempItemSubstitution."Substitute No.";
            TempAssemblyLine."Variant Code" := TempItemSubstitution."Substitute Variant Code";
            SaveQty := TempAssemblyLine.Quantity;
            SaveLocation := TempAssemblyLine."Location Code";
            TempAssemblyLine.Quantity := 0;
            TempAssemblyLine.Validate("No.",TempItemSubstitution."Substitute No.");
            TempAssemblyLine.Validate("Variant Code",TempItemSubstitution."Substitute Variant Code");
            TempAssemblyLine."Location Code" := SaveLocation;
            TempAssemblyLine.Validate(Quantity,SaveQty);
            TempAssemblyLine.Validate("Unit of Measure Code",OldSalesUOM);
            Commit;
            if ItemCheckAvail.AssemblyLineCheck(TempAssemblyLine) then
              TempAssemblyLine := AssemblyLine;
          end;
        end else
          Error(Text001,TempAssemblyLine."No.");

        AssemblyLine := TempAssemblyLine;
    end;

    local procedure IsSubstitutionInserted(var ItemSubstitutionToCheck: Record "Item Substitution";ItemSubstitution: Record "Item Substitution"): Boolean
    begin
        if ItemSubstitution."Substitute No." <> '' then
          with ItemSubstitutionToCheck do begin
            Reset;
            SetRange("Substitute Type",ItemSubstitution."Substitute Type");
            SetRange("Substitute No.",ItemSubstitution."Substitute No.");
            SetRange("Substitute Variant Code",ItemSubstitution."Substitute Variant Code");
            if IsEmpty then
              exit(Insert);
          end;
        exit(false);
    end;
}

