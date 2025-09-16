#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 63 "Sales-Explode BOM"
{
    TableNo = "Sales Line";

    trigger OnRun()
    begin
        TestField(Type,Type::Item);
        TestField("Quantity Shipped",0);
        TestField("Return Qty. Received",0);
        CalcFields("Reserved Qty. (Base)");
        TestField("Reserved Qty. (Base)",0);
        if "Purch. Order Line No." <> 0 then
          Error(
            Text000,
            "Purchase Order No.");
        if "Job Contract Entry No." <> 0 then begin
          TestField("Job No.",'');
          TestField("Job Contract Entry No.",0);
        end;
        SalesHeader.Get("Document Type","Document No.");
        SalesHeader.TestField(Status,SalesHeader.Status::Open);
        FromBOMComp.SetRange("Parent Item No.","No.");
        NoOfBOMComp := FromBOMComp.Count;
        if NoOfBOMComp = 0 then
          Error(
            Text001,
            "No.");

        Selection := StrMenu(Text004,2);
        if Selection = 0 then
          exit;

        if "Document Type" in ["document type"::Order,"document type"::Invoice] then begin
          ToSalesLine := Rec;
          FromBOMComp.SetRange(Type,FromBOMComp.Type::Item);
          FromBOMComp.SetFilter("No.",'<>%1','');
          if FromBOMComp.FindSet then
            repeat
              FromBOMComp.TestField(Type,FromBOMComp.Type::Item);
              Item.Get(FromBOMComp."No.");
              ToSalesLine."Line No." := 0;
              ToSalesLine."No." := FromBOMComp."No.";
              ToSalesLine."Variant Code" := FromBOMComp."Variant Code";
              ToSalesLine."Unit of Measure Code" := FromBOMComp."Unit of Measure Code";
              ToSalesLine."Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,FromBOMComp."Unit of Measure Code");
              ToSalesLine."Outstanding Quantity" := ROUND("Quantity (Base)" * FromBOMComp."Quantity per",0.00001);
              if ToSalesLine."Outstanding Quantity" > 0 then
                if ItemCheckAvail.SalesLineCheck(ToSalesLine) then
                  ItemCheckAvail.RaiseUpdateInterruptedError;
            until FromBOMComp.Next = 0;
        end;

        if "BOM Item No." = '' then
          BOMItemNo := "No."
        else
          BOMItemNo := "BOM Item No.";

        ToSalesLine := Rec;
        ToSalesLine.Init;
        ToSalesLine.Description := Description;
        ToSalesLine."Description 2" := "Description 2";
        ToSalesLine."BOM Item No." := BOMItemNo;
        ToSalesLine.Modify;

        if TransferExtendedText.SalesCheckIfAnyExtText(ToSalesLine,false) then
          TransferExtendedText.InsertSalesExtText(ToSalesLine);

        ExplodeBOMCompLines(Rec);
    end;

    var
        Text000: label 'The BOM cannot be exploded on the sales lines because it is associated with purchase order %1.';
        Text001: label 'Item %1 is not a BOM.';
        Text003: label 'There is not enough space to explode the BOM.';
        Text004: label '&Copy dimensions from BOM,&Retrieve dimensions from components';
        ToSalesLine: Record "Sales Line";
        FromBOMComp: Record "BOM Component";
        SalesHeader: Record "Sales Header";
        ItemTranslation: Record "Item Translation";
        Item: Record Item;
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        UOMMgt: Codeunit "Unit of Measure Management";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        BOMItemNo: Code[20];
        LineSpacing: Integer;
        NextLineNo: Integer;
        NoOfBOMComp: Integer;
        Selection: Integer;

    local procedure ExplodeBOMCompLines(SalesLine: Record "Sales Line")
    var
        PreviousSalesLine: Record "Sales Line";
    begin
        with SalesLine do begin
          ToSalesLine.Reset;
          ToSalesLine.SetRange("Document Type","Document Type");
          ToSalesLine.SetRange("Document No.","Document No.");
          ToSalesLine := SalesLine;
          if ToSalesLine.Find('>') then begin
            LineSpacing := (ToSalesLine."Line No." - "Line No.") DIV (1 + NoOfBOMComp);
            if LineSpacing = 0 then
              Error(Text003);
          end else
            LineSpacing := 10000;

          FromBOMComp.Reset;
          FromBOMComp.SetRange("Parent Item No.","No.");
          FromBOMComp.FindSet;
          NextLineNo := "Line No.";
          repeat
            ToSalesLine.Init;
            NextLineNo := NextLineNo + LineSpacing;
            ToSalesLine."Line No." := NextLineNo;
            case FromBOMComp.Type of
              FromBOMComp.Type::" ":
                ToSalesLine.Type := ToSalesLine.Type::" ";
              FromBOMComp.Type::Item:
                ToSalesLine.Type := ToSalesLine.Type::Item;
              FromBOMComp.Type::Resource:
                ToSalesLine.Type := ToSalesLine.Type::Resource;
            end;
            if ToSalesLine.Type <> ToSalesLine.Type::" " then begin
              FromBOMComp.TestField("No.");
              ToSalesLine.Validate("No.",FromBOMComp."No.");
              if SalesHeader."Location Code" <> "Location Code" then
                ToSalesLine.Validate("Location Code","Location Code");
              if FromBOMComp."Variant Code" <> '' then
                ToSalesLine.Validate("Variant Code",FromBOMComp."Variant Code");
              if ToSalesLine.Type = ToSalesLine.Type::Item then begin
                ToSalesLine."Drop Shipment" := "Drop Shipment";
                Item.Get(FromBOMComp."No.");
                ToSalesLine.Validate("Unit of Measure Code",FromBOMComp."Unit of Measure Code");
                ToSalesLine."Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,ToSalesLine."Unit of Measure Code");
                ToSalesLine.Validate(Quantity,
                  ROUND(
                    "Quantity (Base)" * FromBOMComp."Quantity per" *
                    UOMMgt.GetQtyPerUnitOfMeasure(Item,ToSalesLine."Unit of Measure Code") /
                    ToSalesLine."Qty. per Unit of Measure",
                    0.00001));
              end else
                ToSalesLine.Validate(Quantity,"Quantity (Base)" * FromBOMComp."Quantity per");

              if SalesHeader."Shipment Date" <> "Shipment Date" then
                ToSalesLine.Validate("Shipment Date","Shipment Date");
            end;
            if SalesHeader."Language Code" = '' then
              ToSalesLine.Description := FromBOMComp.Description
            else
              if not ItemTranslation.Get(FromBOMComp."No.",FromBOMComp."Variant Code",SalesHeader."Language Code") then
                ToSalesLine.Description := FromBOMComp.Description;

            ToSalesLine."BOM Item No." := BOMItemNo;
            ToSalesLine.Insert;

            if (ToSalesLine.Type = ToSalesLine.Type::Item) and (ToSalesLine.Reserve = ToSalesLine.Reserve::Always) then
              ToSalesLine.AutoReserve;

            if Selection = 1 then begin
              ToSalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
              ToSalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
              ToSalesLine."Dimension Set ID" := "Dimension Set ID";
              ToSalesLine.Modify;
            end;

            if PreviousSalesLine."Document No." <> '' then
              if TransferExtendedText.SalesCheckIfAnyExtText(PreviousSalesLine,false) then
                TransferExtendedText.InsertSalesExtText(PreviousSalesLine);

            PreviousSalesLine := ToSalesLine;
          until FromBOMComp.Next = 0;

          if TransferExtendedText.SalesCheckIfAnyExtText(ToSalesLine,false) then
            TransferExtendedText.InsertSalesExtText(ToSalesLine);
        end;
    end;
}

