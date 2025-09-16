#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5771 "Whse.-Sales Release"
{

    trigger OnRun()
    begin
    end;

    var
        WhseRqst: Record "Warehouse Request";
        SalesLine: Record "Sales Line";
        Location: Record Location;
        OldLocationCode: Code[10];
        First: Boolean;


    procedure Release(SalesHeader: Record "Sales Header")
    var
        WhseType: Option Inbound,Outbound;
        OldWhseType: Option Inbound,Outbound;
    begin
        with SalesHeader do begin
          case "Document Type" of
            "document type"::Order:
              WhseRqst."Source Document" := WhseRqst."source document"::"Sales Order";
            "document type"::"Return Order":
              WhseRqst."Source Document" := WhseRqst."source document"::"Sales Return Order";
            else
              exit;
          end;

          SalesLine.SetCurrentkey("Document Type","Document No.","Location Code");
          SalesLine.SetRange("Document Type","Document Type");
          SalesLine.SetRange("Document No.","No.");
          SalesLine.SetRange(Type,SalesLine.Type::Item);
          SalesLine.SetRange("Drop Shipment",false);
          SalesLine.SetRange("Job No.",'');
          if SalesLine.FindSet then begin
            First := true;
            repeat
              if (("Document Type" = "document type"::Order) and
                  (SalesLine.Quantity >= 0)) or
                 (("Document Type" = "document type"::"Return Order") and
                  (SalesLine.Quantity < 0))
              then
                WhseType := Whsetype::Outbound
              else
                WhseType := Whsetype::Inbound;

              if First or (SalesLine."Location Code" <> OldLocationCode) or
                 (WhseType <> OldWhseType)
              then
                CreateWhseRqst(SalesHeader,WhseType);

              First := false;
              OldLocationCode := SalesLine."Location Code";
              OldWhseType := WhseType;
            until SalesLine.Next = 0;
          end;

          WhseRqst.Reset;
          WhseRqst.SetCurrentkey("Source Type","Source Subtype","Source No.");
          WhseRqst.SetRange(Type,WhseRqst.Type);
          WhseRqst.SetRange("Source Type",Database::"Sales Line");
          WhseRqst.SetRange("Source Subtype","Document Type");
          WhseRqst.SetRange("Source No.","No.");
          WhseRqst.SetRange("Document Status",Status::Open);
          if not WhseRqst.IsEmpty then
            WhseRqst.DeleteAll(true);
        end;
    end;


    procedure Reopen(SalesHeader: Record "Sales Header")
    var
        WhseRqst: Record "Warehouse Request";
    begin
        with SalesHeader do begin
          case "Document Type" of
            "document type"::Order:
              WhseRqst.Type := WhseRqst.Type::Outbound;
            "document type"::"Return Order":
              WhseRqst.Type := WhseRqst.Type::Inbound;
          end;

          WhseRqst.Reset;
          WhseRqst.SetCurrentkey("Source Type","Source Subtype","Source No.");
          WhseRqst.SetRange(Type,WhseRqst.Type);
          WhseRqst.SetRange("Source Type",Database::"Sales Line");
          WhseRqst.SetRange("Source Subtype","Document Type");
          WhseRqst.SetRange("Source No.","No.");
          WhseRqst.SetRange("Document Status",Status::Released);
          WhseRqst.LockTable;
          if not WhseRqst.IsEmpty then
            WhseRqst.ModifyAll("Document Status",WhseRqst."document status"::Open);
        end;
    end;

    local procedure CreateWhseRqst(var SalesHeader: Record "Sales Header";WhseType: Option Inbound,Outbound)
    var
        SalesLine2: Record "Sales Line";
    begin
        if ((WhseType = Whsetype::Outbound) and
            (Location.RequireShipment(SalesLine."Location Code") or
             Location.RequirePicking(SalesLine."Location Code"))) or
           ((WhseType = Whsetype::Inbound) and
            (Location.RequireReceive(SalesLine."Location Code") or
             Location.RequirePutaway(SalesLine."Location Code")))
        then begin
          SalesLine2.Copy(SalesLine);
          SalesLine2.SetRange("Location Code",SalesLine."Location Code");
          SalesLine2.SetRange("Unit of Measure Code",'');
          if SalesLine2.FindFirst then
            SalesLine2.TestField("Unit of Measure Code");

          WhseRqst.Type := WhseType;
          WhseRqst."Source Type" := Database::"Sales Line";
          WhseRqst."Source Subtype" := SalesHeader."Document Type";
          WhseRqst."Source No." := SalesHeader."No.";
          WhseRqst."Shipment Method Code" := SalesHeader."Shipment Method Code";
          WhseRqst."Shipping Agent Code" := SalesHeader."Shipping Agent Code";
          WhseRqst."Shipping Advice" := SalesHeader."Shipping Advice";
          WhseRqst."Document Status" := SalesHeader.Status::Released;
          WhseRqst."Location Code" := SalesLine."Location Code";
          WhseRqst."Destination Type" := WhseRqst."destination type"::Customer;
          WhseRqst."Destination No." := SalesHeader."Sell-to Customer No.";
          WhseRqst."External Document No." := SalesHeader."External Document No.";
          if WhseType = Whsetype::Inbound then
            WhseRqst."Expected Receipt Date" := SalesHeader."Shipment Date"
          else
            WhseRqst."Shipment Date" := SalesHeader."Shipment Date";
          SalesHeader.SetRange("Location Filter",SalesLine."Location Code");
          SalesHeader.CalcFields("Completely Shipped");
          WhseRqst."Completely Handled" := SalesHeader."Completely Shipped";
          if not WhseRqst.Insert then
            WhseRqst.Modify;
        end;
    end;
}

