#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 76 "Purch.-Get Drop Shpt."
{
    Permissions = TableData "Sales Header"=m,
                  TableData "Sales Line"=m;
    TableNo = "Purchase Header";

    trigger OnRun()
    begin
        PurchHeader.Copy(Rec);
        Code;
        Rec := PurchHeader;
    end;

    var
        Text000: label 'There were no lines to be retrieved from sales order %1.';
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        NextLineNo: Integer;
        Text001: label 'The %1 for %2 %3 has changed from %4 to %5 since the Sales Order was created. Adjust the %6 on the Sales Order or the %1.';

    local procedure "Code"()
    var
        PurchLine2: Record "Purchase Line";
        ItemUnitofMeasure: Record "Item Unit of Measure";
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
          TestField("Ship-to Code",SalesHeader."Ship-to Code");
          if DropShptOrderExists(SalesHeader) then
            AddShipToAddress(SalesHeader,true);

          PurchLine.LockTable;
          SalesLine.LockTable;

          PurchLine.SetRange("Document Type",PurchLine."document type"::Order);
          PurchLine.SetRange("Document No.","No.");
          if PurchLine.FindLast then
            NextLineNo := PurchLine."Line No." + 10000
          else
            NextLineNo := 10000;

          SalesLine.SetRange("Document Type",SalesLine."document type"::Order);
          SalesLine.SetRange("Document No.",SalesHeader."No.");
          SalesLine.SetRange("Drop Shipment",true);
          SalesLine.SetFilter("Outstanding Quantity",'<>0');
          SalesLine.SetRange(Type,SalesLine.Type::Item);
          SalesLine.SetFilter("No.",'<>%1','');
          SalesLine.SetRange("Purch. Order Line No.",0);

          if SalesLine.Find('-') then
            repeat
              if (SalesLine.Type = SalesLine.Type::Item) and ItemUnitofMeasure.Get(SalesLine."No.",SalesLine."Unit of Measure Code") then
                if SalesLine."Qty. per Unit of Measure" <> ItemUnitofMeasure."Qty. per Unit of Measure" then
                  Error(Text001,
                    SalesLine.FieldCaption("Qty. per Unit of Measure"),
                    SalesLine.FieldCaption("Unit of Measure Code"),
                    SalesLine."Unit of Measure Code",
                    SalesLine."Qty. per Unit of Measure",
                    ItemUnitofMeasure."Qty. per Unit of Measure",
                    SalesLine.FieldCaption(Quantity));

              PurchLine.Init;
              PurchLine."Document Type" := PurchLine."document type"::Order;
              PurchLine."Document No." := "No.";
              PurchLine."Line No." := NextLineNo;
              CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,PurchLine);
              GetDescription(PurchLine,SalesLine);
              PurchLine."Sales Order No." := SalesLine."Document No.";
              PurchLine."Sales Order Line No." := SalesLine."Line No.";
              PurchLine."Drop Shipment" := true;
              PurchLine."Purchasing Code" := SalesLine."Purchasing Code";
              Evaluate(PurchLine."Inbound Whse. Handling Time",'<0D>');
              PurchLine.Validate("Inbound Whse. Handling Time");
              PurchLine.Insert;
              NextLineNo := NextLineNo + 10000;

              SalesLine."Unit Cost (LCY)" := PurchLine."Unit Cost (LCY)";
              SalesLine.Validate("Unit Cost (LCY)");
              SalesLine."Purchase Order No." := PurchLine."Document No.";
              SalesLine."Purch. Order Line No." := PurchLine."Line No.";
              SalesLine.Modify;
              ItemTrackingMgt.CopyItemTracking(SalesLine.RowID1,PurchLine.RowID1,true);

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

    local procedure GetDescription(var PurchaseLine: Record "Purchase Line";SalesLine: Record "Sales Line")
    var
        Item: Record Item;
    begin
        if (SalesLine.Type <> SalesLine.Type::Item) or (SalesLine."No." = '') then
          exit;
        Item.Get(SalesLine."No.");

        if GetDescriptionFromItemCrossReference(PurchaseLine,SalesLine,Item) then
          exit;
        if GetDescriptionFromItemTranslation(PurchaseLine,SalesLine) then
          exit;
        if GetDescriptionFromItemVariant(PurchaseLine,SalesLine,Item) then
          exit;
        GetDescriptionFromItem(PurchaseLine,Item);
    end;

    local procedure GetDescriptionFromItemCrossReference(var PurchaseLine: Record "Purchase Line";SalesLine: Record "Sales Line";Item: Record Item): Boolean
    var
        ItemVend: Record "Item Vendor";
        ItemCrossRef: Record "Item Cross Reference";
    begin
        if PurchHeader."Buy-from Vendor No." <> '' then
          if ItemVend.Get(PurchHeader."Buy-from Vendor No.",Item."No.",SalesLine."Variant Code") then
            if ItemCrossRef.Get(
                 Item."No.",SalesLine."Variant Code",SalesLine."Unit of Measure Code",
                 ItemCrossRef."cross-reference type"::Vendor,
                 PurchHeader."Buy-from Vendor No.",ItemVend."Vendor Item No.")
            then begin
              PurchaseLine.Description := ItemCrossRef.Description;
              PurchaseLine."Description 2" := '';
              exit(true);
            end;
        exit(false)
    end;

    local procedure GetDescriptionFromItemTranslation(var PurchaseLine: Record "Purchase Line";SalesLine: Record "Sales Line"): Boolean
    var
        Vend: Record Vendor;
        ItemTranslation: Record "Item Translation";
    begin
        if PurchHeader."Buy-from Vendor No." <> '' then begin
          Vend.Get(PurchHeader."Buy-from Vendor No.");
          if Vend."Language Code" <> '' then
            if ItemTranslation.Get(SalesLine."No.",SalesLine."Variant Code",Vend."Language Code") then begin
              PurchaseLine.Description := ItemTranslation.Description;
              PurchaseLine."Description 2" := ItemTranslation."Description 2";
              exit(true);
            end;
        end;
        exit(false)
    end;

    local procedure GetDescriptionFromItemVariant(var PurchaseLine: Record "Purchase Line";SalesLine: Record "Sales Line";Item: Record Item): Boolean
    var
        ItemVariant: Record "Item Variant";
    begin
        if SalesLine."Variant Code" <> '' then begin
          ItemVariant.Get(Item."No.",SalesLine."Variant Code");
          PurchaseLine.Description := ItemVariant.Description;
          PurchaseLine."Description 2" := ItemVariant."Description 2";
          exit(true);
        end;
        exit(false)
    end;

    local procedure GetDescriptionFromItem(var PurchaseLine: Record "Purchase Line";Item: Record Item)
    begin
        PurchaseLine.Description := Item.Description;
        PurchaseLine."Description 2" := Item."Description 2";
    end;
}

