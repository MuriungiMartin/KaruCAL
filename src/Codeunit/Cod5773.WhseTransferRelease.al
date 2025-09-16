#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5773 "Whse.-Transfer Release"
{

    trigger OnRun()
    begin
    end;

    var
        Location: Record Location;
        WhseMgt: Codeunit "Whse. Management";
        CalledFromTransferOrder: Boolean;


    procedure Release(TransHeader: Record "Transfer Header")
    var
        WhseRqst: Record "Warehouse Request";
    begin
        with TransHeader do begin
          WhseRqst."Source Type" := Database::"Transfer Line";
          WhseRqst."Source No." := "No.";
          WhseRqst."Document Status" := Status::Released;
          WhseRqst."Destination Type" := WhseRqst."destination type"::Location;
          WhseRqst."External Document No." := "External Document No.";

          if Location.RequireReceive("Transfer-to Code") or
             Location.RequirePutaway("Transfer-to Code")
          then begin
            CheckUnitOfMeasureCode("No.");

            WhseRqst.Type := WhseRqst.Type::Inbound;
            WhseRqst."Source Subtype" := 1;
            WhseRqst."Source Document" := WhseMgt.GetSourceDocument(WhseRqst."Source Type",WhseRqst."Source Subtype");
            WhseRqst."Location Code" := "Transfer-to Code";
            SetRange("Location Filter","Transfer-to Code");
            CalcFields("Completely Received");
            WhseRqst."Completely Handled" := "Completely Received";
            WhseRqst."Shipment Method Code" := "Shipment Method Code";
            WhseRqst."Shipping Agent Code" := "Shipping Agent Code";
            WhseRqst."Expected Receipt Date" := "Receipt Date";
            WhseRqst."Destination No." := "Transfer-to Code";
            if CalledFromTransferOrder then begin
              if WhseRqst.Modify then;
            end else
              if not WhseRqst.Insert then
                WhseRqst.Modify;
          end;
          if Location.RequireShipment("Transfer-from Code") or
             Location.RequirePicking("Transfer-from Code")
          then begin
            CheckUnitOfMeasureCode("No.");

            WhseRqst.Type := WhseRqst.Type::Outbound;
            WhseRqst."Location Code" := "Transfer-from Code";
            WhseRqst."Source Subtype" := 0;
            WhseRqst."Source Document" := WhseMgt.GetSourceDocument(WhseRqst."Source Type",WhseRqst."Source Subtype");
            WhseRqst."Shipping Advice" := "Shipping Advice";
            WhseRqst."Shipment Method Code" := "Shipment Method Code";
            WhseRqst."Shipping Agent Code" := "Shipping Agent Code";
            SetRange("Location Filter","Transfer-from Code");
            CalcFields("Completely Shipped");
            WhseRqst."Completely Handled" := "Completely Shipped";
            WhseRqst."Shipment Date" := "Shipment Date";
            WhseRqst."Destination No." := "Transfer-from Code";
            if not WhseRqst.Insert then
              WhseRqst.Modify;
          end;

          WhseRqst.Reset;
          WhseRqst.SetCurrentkey("Source Type","Source No.");
          WhseRqst.SetRange("Source Type",Database::"Transfer Line");
          WhseRqst.SetRange("Source No.","No.");
          WhseRqst.SetRange("Document Status",Status::Open);
          if not WhseRqst.IsEmpty then
            WhseRqst.DeleteAll(true);
        end;
    end;


    procedure Reopen(TransHeader: Record "Transfer Header")
    var
        WhseRqst: Record "Warehouse Request";
    begin
        with TransHeader do begin
          if WhseRqst.Get(WhseRqst.Type::Inbound,"Transfer-to Code",Database::"Transfer Line",1,"No.") then begin
            WhseRqst."Document Status" := Status::Open;
            WhseRqst.Modify;
          end;
          if WhseRqst.Get(WhseRqst.Type::Outbound,"Transfer-from Code",Database::"Transfer Line",0,"No.") then begin
            WhseRqst."Document Status" := Status::Open;
            WhseRqst.Modify;
          end;
        end;
    end;


    procedure SetCallFromTransferOrder(CalledFromTransferOrder2: Boolean)
    begin
        CalledFromTransferOrder := CalledFromTransferOrder2;
    end;

    local procedure CheckUnitOfMeasureCode(DocumentNo: Code[20])
    var
        TransLine: Record "Transfer Line";
    begin
        TransLine.SetRange("Document No.",DocumentNo);
        TransLine.SetRange("Unit of Measure Code",'');
        TransLine.SetFilter("Item No.",'<>%1','');
        if TransLine.FindFirst then
          TransLine.TestField("Unit of Measure Code");
    end;
}

