#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5770 "Whse.-Service Release"
{

    trigger OnRun()
    begin
    end;

    var
        WhseRqst: Record "Warehouse Request";
        ServiceLine: Record "Service Line";
        Location: Record Location;
        OldLocationCode: Code[10];
        First: Boolean;


    procedure Release(ServiceHeader: Record "Service Header")
    var
        WhseType: Option Inbound,Outbound;
        OldWhseType: Option Inbound,Outbound;
    begin
        with ServiceHeader do begin
          if "Document Type" <> "document type"::Order then
            exit;
          WhseRqst."Source Document" := WhseRqst."source document"::"Service Order";

          ServiceLine.SetCurrentkey("Document Type","Document No.","Location Code");
          ServiceLine.SetRange("Document Type","Document Type");
          ServiceLine.SetRange("Document No.","No.");
          ServiceLine.SetRange(Type,ServiceLine.Type::Item);
          ServiceLine.SetRange("Job No.",'');
          if ServiceLine.FindSet then begin
            First := true;
            repeat
              if ("Document Type" = "document type"::Order) and (ServiceLine.Quantity >= 0) then
                WhseType := Whsetype::Outbound
              else
                WhseType := Whsetype::Inbound;

              if First or (ServiceLine."Location Code" <> OldLocationCode) or
                 (WhseType <> OldWhseType)
              then
                CreateWhseRqst(ServiceHeader,WhseType);

              First := false;
              OldLocationCode := ServiceLine."Location Code";
              OldWhseType := WhseType;
            until ServiceLine.Next = 0;
          end;
          SetWhseRqstFiltersByStatus(ServiceHeader,WhseRqst,"release status"::Open);
          WhseRqst.DeleteAll(true);
        end;
    end;


    procedure Reopen(ServiceHeader: Record "Service Header")
    var
        WhseRqst: Record "Warehouse Request";
    begin
        with ServiceHeader do begin
          WhseRqst.Type := WhseRqst.Type::Outbound;
          SetWhseRqstFiltersByStatus(ServiceHeader,WhseRqst,"release status"::"Released to Ship");
          WhseRqst.LockTable;
          if WhseRqst.FindSet then
            repeat
              WhseRqst."Document Status" := "release status"::Open;
              WhseRqst.Modify;
            until WhseRqst.Next = 0;
        end;
    end;

    local procedure CreateWhseRqst(var ServiceHeader: Record "Service Header";WhseType: Option Inbound,Outbound)
    var
        ServiceLine2: Record "Service Line";
    begin
        if ((WhseType = Whsetype::Outbound) and
            (Location.RequireShipment(ServiceLine."Location Code") or
             Location.RequirePicking(ServiceLine."Location Code"))) or
           ((WhseType = Whsetype::Inbound) and
            (Location.RequireReceive(ServiceLine."Location Code") or
             Location.RequirePutaway(ServiceLine."Location Code")))
        then begin
          ServiceLine2.Copy(ServiceLine);
          ServiceLine2.SetRange("Location Code",ServiceLine."Location Code");
          ServiceLine2.SetRange("Unit of Measure Code",'');
          if ServiceLine2.FindFirst then
            ServiceLine2.TestField("Unit of Measure Code");

          with WhseRqst do begin
            Type := WhseType;
            "Source Type" := Database::"Service Line";
            "Source Subtype" := ServiceHeader."Document Type";
            "Source No." := ServiceHeader."No.";
            "Shipping Advice" := ServiceHeader."Shipping Advice";
            "Document Status" := ServiceHeader."release status"::"Released to Ship";
            "Location Code" := ServiceLine."Location Code";
            "Destination Type" := "destination type"::Customer;
            "Destination No." := ServiceHeader."Bill-to Customer No.";
            "External Document No." := '';
            "Shipment Date" := ServiceLine.GetShipmentDate;
            "Shipment Method Code" := ServiceHeader."Shipment Method Code";
            "Shipping Agent Code" := ServiceHeader."Shipping Agent Code";
            "Completely Handled" := CalcCompletelyShipped(ServiceLine);
            if not Insert then
              Modify;
          end;
        end;
    end;

    local procedure CalcCompletelyShipped(ServiceLine: Record "Service Line"): Boolean
    var
        ServiceLineWithItem: Record "Service Line";
    begin
        with ServiceLineWithItem do begin
          SetRange("Document Type",ServiceLine."Document Type");
          SetRange("Document No.",ServiceLine."Document No.");
          SetRange("Location Code",ServiceLine."Location Code");
          SetRange(Type,Type::Item);
          SetRange("Completely Shipped",false);
          exit(IsEmpty);
        end;
    end;

    local procedure SetWhseRqstFiltersByStatus(ServiceHeader: Record "Service Header";var WarehouseRequest: Record "Warehouse Request";Status: Option Open,"Released to Ship",,"Pending Approval","Pending Prepayment")
    begin
        with WarehouseRequest do begin
          Reset;
          SetCurrentkey("Source Type","Source Subtype","Source No.");
          SetRange(Type,Type);
          SetRange("Source Type",Database::"Service Line");
          SetRange("Source Subtype",ServiceHeader."Document Type");
          SetRange("Source No.",ServiceHeader."No.");
          SetRange("Document Status",Status);
        end;
    end;
}

