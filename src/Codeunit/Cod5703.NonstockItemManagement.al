#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5703 "Nonstock Item Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Item %1 already exists.';
        Text001: label 'Item %1 is created.';
        Text002: label 'You cannot enter a nonstock item on %1.';
        Text003: label 'Creating item card for nonstock item\';
        Text004: label 'Manufacturer Code    #1####\';
        Text005: label 'Vendor               #2##################\';
        Text006: label 'Vendor Item          #3##################\';
        Text007: label 'Item No.             #4##################';
        NewItem: Record Item;
        ItemLedgEntry: Record "Item Ledger Entry";
        NonStock: Record "Nonstock Item";
        PurchLine: Record "Purchase Line";
        ItemVend: Record "Item Vendor";
        ServInvLine: Record "Service Line";
        SalesLine: Record "Sales Line";
        BOMComp: Record "BOM Component";
        ProdBOMLine: Record "Production BOM Line";
        ProdBOMHeader: Record "Production BOM Header";
        ProgWindow: Dialog;


    procedure NonstockAutoItem(NonStock2: Record "Nonstock Item")
    begin
        if NewItem.Get(NonStock2."Item No.") then
          Error(Text000,NonStock2."Item No.");

        NonStock2."Item No." :=
          GetNewItemNo(
            NonStock2,StrLen(NonStock2."Vendor Item No."),StrLen(NonStock2."Manufacturer Code"));
        NonStock2.Modify;
        InsertItemUnitOfMeasure(NonStock2."Unit of Measure",NonStock2."Item No.");

        NonStock2.TestField("Vendor No.");
        NonStock2.TestField("Vendor Item No.");
        NonStock2.TestField("Item Template Code");

        if NewItem.Get(NonStock2."Item No.") then
          Error(Text000,NonStock2."Item No.");

        CreateNewItem(NonStock2."Item No.",NonStock2);
        Message(Text001,NonStock2."Item No.");

        if CheckLicensePermission(Database::"Item Vendor") then
          NonstockItemVend(NonStock2);
        if CheckLicensePermission(Database::"Item Cross Reference") then
          NonstockItemCrossRef(NonStock2);
    end;

    local procedure NonstockItemVend(NonStock2: Record "Nonstock Item")
    begin
        ItemVend.SetRange("Item No.",NonStock2."Item No.");
        ItemVend.SetRange("Vendor No.",NonStock2."Vendor No.");
        if ItemVend.FindFirst then
          exit;

        ItemVend."Item No." := NonStock2."Item No.";
        ItemVend."Vendor No." := NonStock2."Vendor No.";
        ItemVend."Vendor Item No." := NonStock2."Vendor Item No.";
        ItemVend.Insert(true);
    end;

    local procedure NonstockItemCrossRef(var NonStock2: Record "Nonstock Item")
    var
        ItemCrossReference: Record "Item Cross Reference";
    begin
        ItemCrossReference.SetRange("Item No.",NonStock2."Item No.");
        ItemCrossReference.SetRange("Unit of Measure",NonStock2."Unit of Measure");
        ItemCrossReference.SetRange("Cross-Reference Type",ItemCrossReference."cross-reference type"::Vendor);
        ItemCrossReference.SetRange("Cross-Reference Type No.",NonStock2."Vendor No.");
        ItemCrossReference.SetRange("Cross-Reference No.",NonStock2."Vendor Item No.");
        if not ItemCrossReference.FindFirst then begin
          ItemCrossReference.Init;
          ItemCrossReference.Validate("Item No.",NonStock2."Item No.");
          ItemCrossReference.Validate("Unit of Measure",NonStock2."Unit of Measure");
          ItemCrossReference.Validate("Cross-Reference Type",ItemCrossReference."cross-reference type"::Vendor);
          ItemCrossReference.Validate("Cross-Reference Type No.",NonStock2."Vendor No.");
          ItemCrossReference.Validate("Cross-Reference No.",NonStock2."Vendor Item No.");
          ItemCrossReference.Insert;
        end;
        if NonStock2."Bar Code" <> '' then begin
          ItemCrossReference.Reset;
          ItemCrossReference.SetRange("Item No.",NonStock2."Item No.");
          ItemCrossReference.SetRange("Unit of Measure",NonStock2."Unit of Measure");
          ItemCrossReference.SetRange("Cross-Reference Type",ItemCrossReference."cross-reference type"::"Bar Code");
          ItemCrossReference.SetRange("Cross-Reference No.",NonStock2."Bar Code");
          if not ItemCrossReference.FindFirst then begin
            ItemCrossReference.Init;
            ItemCrossReference.Validate("Item No.",NonStock2."Item No.");
            ItemCrossReference.Validate("Unit of Measure",NonStock2."Unit of Measure");
            ItemCrossReference.Validate("Cross-Reference Type",ItemCrossReference."cross-reference type"::"Bar Code");
            ItemCrossReference.Validate("Cross-Reference No.",NonStock2."Bar Code");
            ItemCrossReference.Insert;
          end;
        end;
    end;


    procedure NonstockItemDel(var Item: Record Item)
    var
        ItemCrossReference: Record "Item Cross Reference";
    begin
        ItemVend.SetRange("Item No.",Item."No.");
        ItemVend.SetRange("Vendor No.",Item."Vendor No.");
        ItemVend.DeleteAll;

        ItemCrossReference.SetRange("Item No.",Item."No.");
        ItemCrossReference.SetRange("Variant Code",Item."Variant Filter");
        ItemCrossReference.DeleteAll;

        NonStock.SetCurrentkey("Item No.");
        NonStock.SetRange("Item No.",Item."No.");
        if NonStock.Find('-') then
          NonStock.ModifyAll("Item No.",'');
    end;


    procedure NonStockSales(var SalesLine2: Record "Sales Line")
    begin
        if (SalesLine2."Document Type" in
            [SalesLine2."document type"::"Return Order",SalesLine2."document type"::"Credit Memo"])
        then
          Error(Text002,SalesLine2."Document Type");

        NonStock.Get(SalesLine2."No.");
        if NonStock."Item No." <> '' then begin
          SalesLine2."No." := NonStock."Item No.";
          exit;
        end;

        SalesLine2."No." :=
          GetNewItemNo(
            NonStock,StrLen(NonStock."Vendor Item No."),StrLen(NonStock."Manufacturer Code"));
        NonStock."Item No." := SalesLine2."No.";
        NonStock.Modify;
        InsertItemUnitOfMeasure(NonStock."Unit of Measure",SalesLine2."No.");

        NewItem.SetRange("No.",SalesLine2."No.");
        if NewItem.FindFirst then
          exit;

        ProgWindow.Open(Text003 +
          Text004 +
          Text005 +
          Text006 +
          Text007);
        ProgWindow.Update(1,NonStock."Manufacturer Code");
        ProgWindow.Update(2,NonStock."Vendor No.");
        ProgWindow.Update(3,NonStock."Vendor Item No.");
        ProgWindow.Update(4,SalesLine2."No.");

        CreateNewItem(SalesLine2."No.",NonStock);

        if CheckLicensePermission(Database::"Item Vendor") then
          NonstockItemVend(NonStock);
        if CheckLicensePermission(Database::"Item Cross Reference") then
          NonstockItemCrossRef(NonStock);

        ProgWindow.Close;
    end;


    procedure DelNonStockSales(var SalesLine2: Record "Sales Line")
    begin
        if SalesLine2.Nonstock = false then
          exit;

        NewItem.Get(SalesLine2."No.");
        SalesLine2."No." := '';
        SalesLine2.Modify;

        DelNonStockItem(NewItem);
    end;


    procedure DelNonStockPurch(var PurchLine2: Record "Purchase Line")
    begin
        if PurchLine2.Nonstock = false then
          exit;

        NewItem.Get(PurchLine2."No.");
        PurchLine2."No." := '';
        PurchLine2.Modify;

        DelNonStockItem(NewItem);
    end;


    procedure DelNonStockFSM(var ServInvLine2: Record "Service Line")
    begin
        if ServInvLine2.Nonstock = false then
          exit;

        NewItem.Get(ServInvLine2."No.");
        ServInvLine2."No." := '';
        ServInvLine2.Modify;

        DelNonStockItem(NewItem);
    end;


    procedure DelNonStockSalesArch(var SalesLineArchive2: Record "Sales Line Archive")
    begin
        if NewItem.Get(SalesLineArchive2."No.") then begin
          SalesLineArchive2."No." := '';
          SalesLineArchive2.Modify;

          DelNonStockItem(NewItem);
        end;
    end;


    procedure NonStockFSM(var ServInvLine2: Record "Service Line")
    begin
        NonStock.Get(ServInvLine2."No.");
        if NonStock."Item No." <> '' then begin
          ServInvLine2."No." := NonStock."Item No.";
          exit;
        end;

        ServInvLine2."No." :=
          GetNewItemNo(
            NonStock,StrLen(NonStock."Vendor Item No."),StrLen(NonStock."Manufacturer Code"));
        NonStock."Item No." := ServInvLine2."No.";
        NonStock.Modify;
        InsertItemUnitOfMeasure(NonStock."Unit of Measure",ServInvLine2."No.");

        NewItem.SetRange("No.",ServInvLine2."No.");
        if NewItem.FindFirst then
          exit;

        ProgWindow.Open(Text003 +
          Text004 +
          Text005 +
          Text006 +
          Text007);
        ProgWindow.Update(1,NonStock."Manufacturer Code");
        ProgWindow.Update(2,NonStock."Vendor No.");
        ProgWindow.Update(3,NonStock."Vendor Item No.");
        ProgWindow.Update(4,ServInvLine2."No.");

        CreateNewItem(ServInvLine2."No.",NonStock);

        if CheckLicensePermission(Database::"Item Vendor") then
          NonstockItemVend(NonStock);
        if CheckLicensePermission(Database::"Item Cross Reference") then
          NonstockItemCrossRef(NonStock);

        ProgWindow.Close;
    end;


    procedure CreateItemFromNonstock(Nonstock2: Record "Nonstock Item")
    begin
        if NewItem.Get(Nonstock2."Item No.") then
          Error(Text000,Nonstock2."Item No.");

        Nonstock2."Item No." :=
          GetNewItemNo(
            Nonstock2,StrLen(Nonstock2."Vendor Item No."),StrLen(Nonstock2."Manufacturer Code"));
        Nonstock2.Modify;
        InsertItemUnitOfMeasure(Nonstock2."Unit of Measure",Nonstock2."Item No.");

        Nonstock2.TestField("Vendor No.");
        Nonstock2.TestField("Vendor Item No.");
        Nonstock2.TestField("Item Template Code");

        if NewItem.Get(Nonstock2."Item No.") then
          Error(Text000,Nonstock2."Item No.");

        CreateNewItem(Nonstock2."Item No.",Nonstock2);

        if CheckLicensePermission(Database::"Item Vendor") then
          NonstockItemVend(Nonstock2);
        if CheckLicensePermission(Database::"Item Cross Reference") then
          NonstockItemCrossRef(Nonstock2);
    end;

    local procedure CheckLicensePermission(TableID: Integer): Boolean
    var
        LicensePermission: Record "License Permission";
    begin
        LicensePermission.SetRange("Object Type",LicensePermission."object type"::TableData);
        LicensePermission.SetRange("Object Number",TableID);
        LicensePermission.SetFilter("Insert Permission",'<>%1',LicensePermission."insert permission"::" ");
        exit(LicensePermission.FindFirst);
    end;

    local procedure DelNonStockItem(var Item: Record Item)
    var
        SalesLineArch: Record "Sales Line Archive";
    begin
        ItemLedgEntry.SetCurrentkey("Item No.");
        ItemLedgEntry.SetRange("Item No.",Item."No.");
        if ItemLedgEntry.FindFirst then
          exit;

        SalesLine.SetCurrentkey(Type,"No.");
        SalesLine.SetRange(Type,SalesLine.Type::Item);
        SalesLine.SetRange("No.",Item."No.");
        if SalesLine.FindFirst then
          exit;

        PurchLine.SetCurrentkey(Type,"No.");
        PurchLine.SetRange(Type,PurchLine.Type::Item);
        PurchLine.SetRange("No.",Item."No.");
        if PurchLine.FindFirst then
          exit;

        ServInvLine.SetCurrentkey(Type,"No.");
        ServInvLine.SetRange(Type,ServInvLine.Type::Item);
        ServInvLine.SetRange("No.",Item."No.");
        if ServInvLine.FindFirst then
          exit;

        BOMComp.SetCurrentkey(Type,"No.");
        BOMComp.SetRange(Type,BOMComp.Type::Item);
        BOMComp.SetRange("No.",Item."No.");
        if BOMComp.FindFirst then
          exit;

        SalesLineArch.SetCurrentkey(Type,"No.");
        SalesLineArch.SetRange(Type,SalesLineArch.Type::Item);
        SalesLineArch.SetRange("No.",Item."No.");
        if not SalesLineArch.IsEmpty then
          exit;

        ProdBOMLine.Reset;
        ProdBOMLine.SetCurrentkey(Type,"No.");
        ProdBOMLine.SetRange(Type,ProdBOMLine.Type::Item);
        ProdBOMLine.SetRange("No.",Item."No.");
        if ProdBOMLine.Find('-') then
          repeat
            if ProdBOMHeader.Get(ProdBOMLine."Production BOM No.") and
               (ProdBOMHeader.Status = ProdBOMHeader.Status::Certified)
            then
              exit;
          until ProdBOMLine.Next = 0;

        NewItem.Get(Item."No.");
        if NewItem.Delete(true) then begin
          NonStock.SetRange("Item No.",Item."No.");
          if NonStock.Find('-') then
            repeat
              NonStock."Item No." := '';
              NonStock.Modify;
            until NonStock.Next = 0;
        end;
    end;

    local procedure InsertItemUnitOfMeasure(UnitOfMeasureCode: Code[10];ItemNo: Code[20])
    var
        UnitOfMeasure: Record "Unit of Measure";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UnitOfMeasureCode) then begin
          UnitOfMeasure.Code := UnitOfMeasureCode;
          UnitOfMeasure.Insert;
        end;
        if not ItemUnitOfMeasure.Get(ItemNo,UnitOfMeasureCode) then begin
          ItemUnitOfMeasure."Item No." := ItemNo;
          ItemUnitOfMeasure.Code := UnitOfMeasureCode;
          ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
          ItemUnitOfMeasure.Insert;
        end;
    end;

    local procedure GetNewItemNo(NonstockItem: Record "Nonstock Item";Length1: Integer;Length2: Integer) NewItemNo: Code[20]
    var
        NonstockItemSetupMy: Record "Nonstock Item Setup";
    begin
        NonstockItemSetupMy.Get;
        case NonstockItemSetupMy."No. Format" of
          NonstockItemSetupMy."no. format"::"Vendor Item No.":
            NewItemNo := NonstockItem."Vendor Item No.";
          NonstockItemSetupMy."no. format"::"Mfr. + Vendor Item No.":
            if NonstockItemSetupMy."No. Format Separator" = '' then begin
              if Length1 + Length2 <= 20 then
                Evaluate(NewItemNo,NonstockItem."Manufacturer Code" + NonstockItem."Vendor Item No.")
              else
                Evaluate(NewItemNo,NonstockItem."Manufacturer Code" + NonstockItem."Entry No.");
            end else begin
              if Length1 + Length2 < 20 then
                Evaluate(
                  NewItemNo,
                  NonstockItem."Manufacturer Code" + NonstockItemSetupMy."No. Format Separator" + NonstockItem."Vendor Item No.")
              else
                Evaluate(
                  NewItemNo,
                  NonstockItem."Manufacturer Code" + NonstockItemSetupMy."No. Format Separator" + NonstockItem."Entry No.");
            end;
          NonstockItemSetupMy."no. format"::"Vendor Item No. + Mfr.":
            if NonstockItemSetupMy."No. Format Separator" = '' then begin
              if Length1 + Length2 <= 20 then
                Evaluate(NewItemNo,NonstockItem."Vendor Item No." + NonstockItem."Manufacturer Code")
              else
                Evaluate(NewItemNo,NonstockItem."Entry No." + NonstockItem."Manufacturer Code");
            end else begin
              if Length1 + Length2 < 20 then
                Evaluate(
                  NewItemNo,
                  NonstockItem."Vendor Item No." + NonstockItemSetupMy."No. Format Separator" + NonstockItem."Manufacturer Code")
              else
                Evaluate(
                  NewItemNo,
                  NonstockItem."Entry No." + NonstockItemSetupMy."No. Format Separator" + NonstockItem."Manufacturer Code");
            end;
          NonstockItemSetupMy."no. format"::"Entry No.":
            NewItemNo := NonstockItem."Entry No.";
        end;
    end;

    local procedure CreateNewItem(ItemNo: Code[20];NonstockItem: Record "Nonstock Item")
    var
        Item: Record Item;
        DummyItemTemplate: Record "Item Template";
        ConfigTemplateHeader: Record "Config. Template Header";
    begin
        Item.Init;

        ConfigTemplateHeader.SetRange(Code,NonstockItem."Item Template Code");
        ConfigTemplateHeader.FindFirst;
        DummyItemTemplate.InitializeTempRecordFromConfigTemplate(DummyItemTemplate,ConfigTemplateHeader);
        Item."Inventory Posting Group" := DummyItemTemplate."Inventory Posting Group";
        Item."Costing Method" := DummyItemTemplate."Costing Method";
        Item."Gen. Prod. Posting Group" := DummyItemTemplate."Gen. Prod. Posting Group";
        Item."Tax Group Code" := DummyItemTemplate."Tax Group Code";
        Item."VAT Prod. Posting Group" := DummyItemTemplate."VAT Prod. Posting Group";

        Item."No." := ItemNo;
        Item.Description := NonstockItem.Description;
        Item.Validate(Description,Item.Description);
        Item.Validate("Base Unit of Measure",NonstockItem."Unit of Measure");
        Item."Unit Price" := NonstockItem."Unit Price";
        Item."Unit Cost" := NonstockItem."Negotiated Cost";
        Item."Last Direct Cost" := NonstockItem."Negotiated Cost";
        if Item."Costing Method" = Item."costing method"::Standard then
          Item."Standard Cost" := NonstockItem."Negotiated Cost";
        Item."Automatic Ext. Texts" := false;
        Item."Vendor No." := NonstockItem."Vendor No.";
        Item."Vendor Item No." := NonstockItem."Vendor Item No.";
        Item."Net Weight" := NonstockItem."Net Weight";
        Item."Gross Weight" := NonstockItem."Gross Weight";
        Item."Manufacturer Code" := NonstockItem."Manufacturer Code";
        Item."Item Category Code" := DummyItemTemplate."Item Category Code";
        Item."Product Group Code" := NonstockItem."Product Group Code";
        Item."Created From Nonstock Item" := true;
        Item.Insert;
    end;
}

