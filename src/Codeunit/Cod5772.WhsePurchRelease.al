#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5772 "Whse.-Purch. Release"
{

    trigger OnRun()
    begin
    end;

    var
        WhseRqst: Record "Warehouse Request";
        PurchLine: Record "Purchase Line";
        Location: Record Location;
        OldLocationCode: Code[10];
        First: Boolean;


    procedure Release(PurchHeader: Record "Purchase Header")
    var
        WhseType: Option Inbound,Outbound;
        OldWhseType: Option Inbound,Outbound;
    begin
        with PurchHeader do begin
          case "Document Type" of
            "document type"::Order:
              WhseRqst."Source Document" := WhseRqst."source document"::"Purchase Order";
            "document type"::"Return Order":
              WhseRqst."Source Document" := WhseRqst."source document"::"Purchase Return Order";
            else
              exit;
          end;

          PurchLine.SetCurrentkey("Document Type","Document No.","Location Code");
          PurchLine.SetRange("Document Type","Document Type");
          PurchLine.SetRange("Document No.","No.");
          PurchLine.SetRange(Type,PurchLine.Type::Item);
          PurchLine.SetRange("Drop Shipment",false);
          PurchLine.SetRange("Job No.",'');
          PurchLine.SetRange("Work Center No.",'');
          if PurchLine.Find('-') then begin
            First := true;
            repeat
              if (("Document Type" = "document type"::Order) and
                  (PurchLine.Quantity >= 0)) or
                 (("Document Type" = "document type"::"Return Order") and
                  (PurchLine.Quantity < 0))
              then
                WhseType := Whsetype::Inbound
              else
                WhseType := Whsetype::Outbound;
              if First or (PurchLine."Location Code" <> OldLocationCode) or
                 (WhseType <> OldWhseType)
              then
                CreateWhseRqst(PurchHeader,WhseType);
              First := false;
              OldLocationCode := PurchLine."Location Code";
              OldWhseType := WhseType;
            until PurchLine.Next = 0;
          end;

          FilterWarehouseRequest(WhseRqst,PurchHeader,WhseRqst."document status"::Open);
          if not WhseRqst.IsEmpty then
            WhseRqst.DeleteAll(true);
        end;
    end;


    procedure Reopen(PurchHeader: Record "Purchase Header")
    begin
        with PurchHeader do begin
          case "Document Type" of
            "document type"::Order:
              WhseRqst.Type := WhseRqst.Type::Inbound;
            "document type"::"Return Order":
              WhseRqst.Type := WhseRqst.Type::Outbound;
          end;

          FilterWarehouseRequest(WhseRqst,PurchHeader,WhseRqst."document status"::Released);
          if not WhseRqst.IsEmpty then
            WhseRqst.ModifyAll("Document Status",WhseRqst."document status"::Open);
        end;
    end;

    local procedure CreateWhseRqst(var PurchHeader: Record "Purchase Header";WhseType: Option Inbound,Outbound)
    var
        PurchLine2: Record "Purchase Line";
    begin
        if ((WhseType = Whsetype::Outbound) and
            (Location.RequireShipment(PurchLine."Location Code") or
             Location.RequirePicking(PurchLine."Location Code"))) or
           ((WhseType = Whsetype::Inbound) and
            (Location.RequireReceive(PurchLine."Location Code") or
             Location.RequirePutaway(PurchLine."Location Code")))
        then begin
          PurchLine2.Copy(PurchLine);
          PurchLine2.SetRange("Location Code",PurchLine."Location Code");
          PurchLine2.SetRange("Unit of Measure Code",'');
          if PurchLine2.FindFirst then
            PurchLine2.TestField("Unit of Measure Code");

          WhseRqst.Type := WhseType;
          WhseRqst."Source Type" := Database::"Purchase Line";
          WhseRqst."Source Subtype" := PurchHeader."Document Type";
          WhseRqst."Source No." := PurchHeader."No.";
          WhseRqst."Shipment Method Code" := PurchHeader."Shipment Method Code";
          WhseRqst."Document Status" := PurchHeader.Status::Released;
          WhseRqst."Location Code" := PurchLine."Location Code";
          WhseRqst."Destination Type" := WhseRqst."destination type"::Vendor;
          WhseRqst."Destination No." := PurchHeader."Buy-from Vendor No.";
          WhseRqst."External Document No." := PurchHeader."Vendor Shipment No.";
          if WhseType = Whsetype::Inbound then
            WhseRqst."Expected Receipt Date" := PurchHeader."Expected Receipt Date"
          else
            WhseRqst."Shipment Date" := PurchHeader."Expected Receipt Date";
          PurchHeader.SetRange("Location Filter",PurchLine."Location Code");
          PurchHeader.CalcFields("Completely Received");
          WhseRqst."Completely Handled" := PurchHeader."Completely Received";
          if not WhseRqst.Insert then
            WhseRqst.Modify;
        end;
    end;

    local procedure FilterWarehouseRequest(var WarehouseRequest: Record "Warehouse Request";PurchaseHeader: Record "Purchase Header";DocumentStatus: Option)
    begin
        with WarehouseRequest do begin
          Reset;
          SetCurrentkey("Source Type","Source Subtype","Source No.");
          SetRange(Type,Type);
          SetRange("Source Type",Database::"Purchase Line");
          SetRange("Source Subtype",PurchaseHeader."Document Type");
          SetRange("Source No.",PurchaseHeader."No.");
          SetRange("Document Status",DocumentStatus);
        end;
    end;
}

