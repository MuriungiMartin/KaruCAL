#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5702 "Dist. Integration"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'There are no items with cross reference: %1';
        ItemCrossReference: Record "Item Cross Reference";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        ItemVariant: Record "Item Variant";
        Item: Record Item;
        Found: Boolean;
        TempCrossRefItem: Code[20];
        Text001: label 'The Quantity per Unit of Measure for Unit of Measure Code %1 has changed from %2 to %3 since the sales order was created. Adjust the quantity on the sales order or the %1.';


    procedure EnterSalesItemCrossRef(var SalesLine2: Record "Sales Line")
    begin
        with SalesLine2 do
          if Type = Type::Item then begin
            ItemCrossReference.Reset;
            ItemCrossReference.SetRange("Item No.","No.");
            ItemCrossReference.SetRange("Variant Code","Variant Code");
            ItemCrossReference.SetRange("Unit of Measure","Unit of Measure Code");
            ItemCrossReference.SetRange("Cross-Reference Type","cross-reference type"::Customer);
            ItemCrossReference.SetRange("Cross-Reference Type No.","Sell-to Customer No.");
            ItemCrossReference.SetRange("Cross-Reference No.","Cross-Reference No.");
            if ItemCrossReference.Find('-') then
              Found := true
            else begin
              ItemCrossReference.SetRange("Cross-Reference No.");
              Found := ItemCrossReference.Find('-');
            end;

            if Found then begin
              "Cross-Reference No." := ItemCrossReference."Cross-Reference No.";
              "Unit of Measure (Cross Ref.)" := ItemCrossReference."Unit of Measure";
              "Cross-Reference Type" := ItemCrossReference."Cross-Reference Type";
              if ItemCrossReference.Description <> '' then begin
                Description := ItemCrossReference.Description;
                "Description 2" := '';
              end;
              "Cross-Reference Type No." := ItemCrossReference."Cross-Reference Type No.";
            end else begin
              "Cross-Reference No." := '';
              "Cross-Reference Type" := "cross-reference type"::" ";
              "Cross-Reference Type No." := '';
              if "Variant Code" <> '' then begin
                ItemVariant.Get("No.","Variant Code");
                Description := ItemVariant.Description;
                "Description 2" := ItemVariant."Description 2";
              end else begin
                Item.Get("No.");
                Description := Item.Description;
                "Description 2" := Item."Description 2";
              end;
              GetItemTranslation;
            end;
          end;
    end;


    procedure ICRLookupSalesItem(var SalesLine2: Record "Sales Line";var ReturnedCrossRef: Record "Item Cross Reference")
    begin
        with ItemCrossReference do begin
          SalesLine.Copy(SalesLine2);
          if SalesLine.Type = SalesLine.Type::Item then begin
            TempCrossRefItem := SalesLine2."Cross-Reference No.";

            Reset;
            SetCurrentkey(
              "Cross-Reference No.","Cross-Reference Type","Cross-Reference Type No.","Discontinue Bar Code");
            SetRange("Cross-Reference No.",SalesLine."Cross-Reference No.");
            SetFilter("Cross-Reference Type",'<> %1',"cross-reference type"::Vendor);
            SetRange("Discontinue Bar Code",false);
            SetFilter("Cross-Reference Type No.",'%1|%2',SalesLine."Sell-to Customer No.",'');
            SetRange("Item No.",SalesLine."No.");
            if not Find('-') then begin
              SetRange("Item No.");
              if not Find('-') then
                Error(Text000,TempCrossRefItem);
              if Next <> 0 then begin
                SetRange("Cross-Reference Type No.",SalesLine."Sell-to Customer No.");
                if Find('-') then
                  if Next <> 0 then begin
                    SetRange("Cross-Reference Type No.");
                    if Page.RunModal(Page::"Cross Reference List",ItemCrossReference) <> Action::LookupOK
                    then
                      Error(Text000,TempCrossRefItem);
                  end;
              end;
            end;
            ReturnedCrossRef.Copy(ItemCrossReference);
          end;
        end;
    end;


    procedure EnterPurchaseItemCrossRef(var PurchLine2: Record "Purchase Line")
    begin
        with PurchLine2 do
          if Type = Type::Item then begin
            ItemCrossReference.Reset;
            ItemCrossReference.SetRange("Item No.","No.");
            ItemCrossReference.SetRange("Variant Code","Variant Code");
            ItemCrossReference.SetRange("Unit of Measure","Unit of Measure Code");
            ItemCrossReference.SetRange("Cross-Reference Type","cross-reference type"::Vendor);
            ItemCrossReference.SetRange("Cross-Reference Type No.","Buy-from Vendor No.");
            ItemCrossReference.SetRange("Cross-Reference No.","Cross-Reference No.");
            if ItemCrossReference.Find('-') then
              Found := true
            else begin
              ItemCrossReference.SetRange("Cross-Reference No.");
              Found := ItemCrossReference.Find('-');
            end;

            if Found then begin
              "Cross-Reference No." := ItemCrossReference."Cross-Reference No.";
              "Unit of Measure (Cross Ref.)" := ItemCrossReference."Unit of Measure";
              "Cross-Reference Type" := ItemCrossReference."Cross-Reference Type";
              "Cross-Reference Type No." := ItemCrossReference."Cross-Reference Type No.";
              if ItemCrossReference.Description <> '' then begin
                Description := ItemCrossReference.Description;
                "Description 2" := '';
              end;
            end else begin
              "Cross-Reference No." := '';
              "Cross-Reference Type" := "cross-reference type"::" ";
              "Cross-Reference Type No." := '';
              if "Variant Code" <> '' then begin
                ItemVariant.Get("No.","Variant Code");
                Description := ItemVariant.Description;
                "Description 2" := ItemVariant."Description 2";
              end else begin
                Item.Get("No.");
                Description := Item.Description;
                "Description 2" := Item."Description 2";
              end;
              GetItemTranslation;
            end;
          end;
    end;


    procedure ICRLookupPurchaseItem(var PurchLine2: Record "Purchase Line";var ReturnedCrossRef: Record "Item Cross Reference")
    begin
        with ItemCrossReference do begin
          PurchLine.Copy(PurchLine2);
          if PurchLine.Type = PurchLine.Type::Item then begin
            TempCrossRefItem := PurchLine2."Cross-Reference No.";
            Reset;
            SetCurrentkey("Cross-Reference No.","Cross-Reference Type","Cross-Reference Type No.","Discontinue Bar Code");
            SetRange("Cross-Reference No.",PurchLine."Cross-Reference No.");
            SetFilter("Cross-Reference Type",'<> %1',"cross-reference type"::Customer);
            SetRange("Discontinue Bar Code",false);
            SetFilter("Cross-Reference Type No.",'%1|%2',PurchLine."Buy-from Vendor No.",'');
            SetRange("Item No.",PurchLine."No.");
            if not Find('-') then begin
              SetRange("Item No.");
              if not Find('-') then
                Error(Text000,TempCrossRefItem);
              if Next <> 0 then begin
                SetRange("Cross-Reference Type No.",PurchLine."Buy-from Vendor No.");
                if Find('-') then
                  if Next <> 0 then begin
                    SetRange("Cross-Reference Type No.");
                    if Page.RunModal(Page::"Cross Reference List",ItemCrossReference) <> Action::LookupOK
                    then
                      Error(Text000,TempCrossRefItem);
                  end;
              end;
            end;
            ReturnedCrossRef.Copy(ItemCrossReference);
          end;
        end;
    end;

    local procedure CreateItemCrossReference(ItemVend: Record "Item Vendor")
    var
        Item: Record Item;
        ItemCrossReference2: Record "Item Cross Reference";
        Vend: Record Vendor;
        ItemTranslation: Record "Item Translation";
    begin
        ItemCrossReference2.Reset;
        ItemCrossReference2.SetRange("Item No.",ItemVend."Item No.");
        ItemCrossReference2.SetRange("Variant Code",ItemVend."Variant Code");
        ItemCrossReference2.SetRange("Cross-Reference Type",ItemCrossReference2."cross-reference type"::Vendor);
        ItemCrossReference2.SetRange("Cross-Reference Type No.",ItemVend."Vendor No.");
        ItemCrossReference2.SetRange("Cross-Reference No.",ItemVend."Vendor Item No.");
        if not ItemCrossReference2.FindFirst then begin
          ItemCrossReference2.Init;
          ItemCrossReference2.Validate("Item No.",ItemVend."Item No.");
          ItemCrossReference2.Validate("Variant Code",ItemVend."Variant Code");
          ItemCrossReference2.Validate("Cross-Reference Type",ItemCrossReference2."cross-reference type"::Vendor);
          ItemCrossReference2.Validate("Cross-Reference Type No.",ItemVend."Vendor No.");
          ItemCrossReference2."Cross-Reference No." := ItemVend."Vendor Item No.";
          Item.Get(ItemVend."Item No.");
          ItemCrossReference2.Description := Item.Description;
          if Vend.Get(ItemVend."Vendor No.") then
            if Vend."Language Code" <> '' then
              if ItemTranslation.Get(Item."No.",ItemVend."Variant Code",Vend."Language Code") then
                ItemCrossReference2.Description := ItemTranslation.Description;
          if ItemCrossReference2."Unit of Measure" = '' then
            ItemCrossReference2.Validate("Unit of Measure",Item."Base Unit of Measure");
          ItemCrossReference2.Insert;
        end;
    end;


    procedure DeleteItemCrossReference(ItemVend: Record "Item Vendor")
    var
        ItemCrossReference2: Record "Item Cross Reference";
    begin
        ItemCrossReference2.Reset;
        ItemCrossReference2.SetRange("Item No.",ItemVend."Item No.");
        ItemCrossReference2.SetRange("Variant Code",ItemVend."Variant Code");
        ItemCrossReference2.SetRange("Cross-Reference Type",ItemCrossReference2."cross-reference type"::Vendor);
        ItemCrossReference2.SetRange("Cross-Reference Type No.",ItemVend."Vendor No.");
        ItemCrossReference2.SetRange("Cross-Reference No.",ItemVend."Vendor Item No.");
        if ItemCrossReference2.FindFirst then
          ItemCrossReference2.DeleteAll;
    end;


    procedure UpdateItemCrossReference(ItemVend: Record "Item Vendor";xItemVend: Record "Item Vendor")
    var
        ItemCrossReference2: Record "Item Cross Reference";
        ItemCrossReference3: Record "Item Cross Reference";
    begin
        ItemCrossReference2.Reset;
        ItemCrossReference2.SetRange("Item No.",xItemVend."Item No.");
        ItemCrossReference2.SetRange("Variant Code",xItemVend."Variant Code");
        ItemCrossReference2.SetRange("Cross-Reference Type",ItemCrossReference2."cross-reference type"::Vendor);
        ItemCrossReference2.SetRange("Cross-Reference Type No.",xItemVend."Vendor No.");
        ItemCrossReference2.SetRange("Cross-Reference No.",xItemVend."Vendor Item No.");
        if ItemCrossReference2.FindSet then begin
          repeat
            ItemCrossReference3 := ItemCrossReference2;
            ItemCrossReference3."Cross-Reference No." := xItemVend."Vendor Item No.";
            ItemCrossReference3.Delete;
            CreateItemCrossReference(ItemVend);
          until ItemCrossReference2.Next = 0;
        end else
          CreateItemCrossReference(ItemVend);
    end;


    procedure GetSpecialOrders(var PurchHeader: Record "Purchase Header")
    var
        SalesHeader: Record "Sales Header";
        PurchLine2: Record "Purchase Line";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        Vendor: Record Vendor;
        TransferExtendedText: Codeunit "Transfer Extended Text";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        NextLineNo: Integer;
    begin
        with PurchHeader do begin
          TestField("Document Type","document type"::Order);

          SalesHeader.SetCurrentkey("Document Type","Sell-to Customer No.");
          SalesHeader.SetRange("Document Type",SalesHeader."document type"::Order);
          SalesHeader.SetRange("Sell-to Customer No.","Sell-to Customer No.");
          if (Page.RunModal(Page::"Sales List",SalesHeader) <> Action::LookupOK) or
             (SalesHeader."No." = '')
          then
            exit;
          LockTable;
          SalesHeader.TestField("Document Type",SalesHeader."document type"::Order);
          TestField("Sell-to Customer No.",SalesHeader."Sell-to Customer No.");
          if "Ship-to Code" <> '' then
            TestField("Ship-to Code",SalesHeader."Ship-to Code");
          if SpecialOrderExists(SalesHeader) then
            AddSpecialOrderToAddress(SalesHeader,true);

          if Vendor.Get("Buy-from Vendor No.") then
            Validate("Shipment Method Code",Vendor."Shipment Method Code");

          PurchLine.LockTable;
          SalesLine.LockTable;

          PurchLine.SetRange("Document Type",PurchLine."document type"::Order);
          PurchLine.SetRange("Document No.","No.");
          if PurchLine.FindLast then
            NextLineNo := PurchLine."Line No." + 10000
          else
            NextLineNo := 10000;

          SalesLine.Reset;
          SalesLine.SetRange("Document Type",SalesLine."document type"::Order);
          SalesLine.SetRange("Document No.",SalesHeader."No.");
          SalesLine.SetRange("Special Order",true);
          SalesLine.SetFilter("Outstanding Quantity",'<>0');
          SalesLine.SetRange(Type,SalesLine.Type::Item);
          SalesLine.SetFilter("No.",'<>%1','');
          SalesLine.SetRange("Special Order Purch. Line No.",0);

          if SalesLine.FindSet then
            repeat
              if (SalesLine.Type = SalesLine.Type::Item) and ItemUnitOfMeasure.Get(SalesLine."No.",SalesLine."Unit of Measure Code") then
                if SalesLine."Qty. per Unit of Measure" <> ItemUnitOfMeasure."Qty. per Unit of Measure" then
                  Error(Text001,
                    SalesLine."Unit of Measure Code",
                    SalesLine."Qty. per Unit of Measure",
                    ItemUnitOfMeasure."Qty. per Unit of Measure");
              PurchLine.Init;
              PurchLine."Document Type" := PurchLine."document type"::Order;
              PurchLine."Document No." := "No.";
              PurchLine."Line No." := NextLineNo;
              CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,PurchLine);
              PurchLine."Special Order" := true;
              PurchLine."Purchasing Code" := SalesLine."Purchasing Code";
              PurchLine."Special Order Sales No." := SalesLine."Document No.";
              PurchLine."Special Order Sales Line No." := SalesLine."Line No.";
              PurchLine.Insert;
              NextLineNo := NextLineNo + 10000;

              SalesLine."Unit Cost (LCY)" := PurchLine."Unit Cost (LCY)";
              SalesLine.Validate("Unit Cost (LCY)");
              SalesLine."Special Order Purchase No." := PurchLine."Document No.";
              SalesLine."Special Order Purch. Line No." := PurchLine."Line No.";
              SalesLine.Modify;
              if TransferExtendedText.PurchCheckIfAnyExtText(PurchLine,true) then begin
                TransferExtendedText.InsertPurchExtText(PurchLine);
                PurchLine2.SetRange("Document Type","Document Type");
                PurchLine2.SetRange("Document No.","No.");
                if PurchLine2.FindLast then
                  NextLineNo := PurchLine2."Line No.";
                NextLineNo := NextLineNo + 10000;
              end;
            until SalesLine.Next = 0
          else
            Error(
              Text000,
              SalesHeader."No.");

          Modify; // Only version check
          SalesHeader.Modify; // Only version check
        end;
    end;
}

