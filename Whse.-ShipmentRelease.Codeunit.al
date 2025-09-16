#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7310 "Whse.-Shipment Release"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'There is nothing to release for %1 %2.';
        Text001: label 'You cannot reopen the shipment because warehouse worksheet lines exist that must first be handled or deleted.';
        Text002: label 'You cannot reopen the shipment because warehouse activity lines exist that must first be handled or deleted.';


    procedure Release(var WhseShptHeader: Record "Warehouse Shipment Header")
    var
        Location: Record Location;
        WhsePickRqst: Record "Whse. Pick Request";
        WhseShptLine: Record "Warehouse Shipment Line";
        ATOLink: Record "Assemble-to-Order Link";
        AsmLine: Record "Assembly Line";
    begin
        with WhseShptHeader do begin
          if Status = Status::Released then
            exit;

          WhseShptLine.SetRange("No.","No.");
          WhseShptLine.SetFilter(Quantity,'<>0');
          if not WhseShptLine.Find('-') then
            Error(Text000,TableCaption,"No.");

          if "Location Code" <> '' then
            Location.Get("Location Code");

          repeat
            WhseShptLine.TestField("Item No.");
            WhseShptLine.TestField("Unit of Measure Code");
            if Location."Directed Put-away and Pick" then
              WhseShptLine.TestField("Zone Code");
            if Location."Bin Mandatory" then begin
              WhseShptLine.TestField("Bin Code");
              if WhseShptLine."Assemble to Order" then begin
                ATOLink.AsmExistsForWhseShptLine(WhseShptLine);
                AsmLine.SetCurrentkey("Document Type","Document No.",Type);
                AsmLine.SetRange("Document Type",ATOLink."Assembly Document Type");
                AsmLine.SetRange("Document No.",ATOLink."Assembly Document No.");
                AsmLine.SetRange(Type,AsmLine.Type::Item);
                if AsmLine.FindSet then
                  repeat
                    if AsmLine.CalcQtyToPickBase > 0 then
                      AsmLine.TestField("Bin Code");
                  until AsmLine.Next = 0;
              end;
            end;
          until WhseShptLine.Next = 0;

          Status := Status::Released;
          Modify;

          CreateWhsePickRqst(WhseShptHeader);

          WhsePickRqst.SetRange("Document Type",WhsePickRqst."document type"::Shipment);
          WhsePickRqst.SetRange("Document No.","No.");
          WhsePickRqst.SetRange(Status,Status::Open);
          if not WhsePickRqst.IsEmpty then
            WhsePickRqst.DeleteAll(true);

          Commit;
        end;
    end;


    procedure Reopen(WhseShptHeader: Record "Warehouse Shipment Header")
    var
        WhsePickRqst: Record "Whse. Pick Request";
        PickWkshLine: Record "Whse. Worksheet Line";
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        with WhseShptHeader do begin
          if Status = Status::Open then
            exit;

          PickWkshLine.SetCurrentkey("Whse. Document Type","Whse. Document No.");
          PickWkshLine.SetRange("Whse. Document Type",PickWkshLine."whse. document type"::Shipment);
          PickWkshLine.SetRange("Whse. Document No.","No.");
          if not PickWkshLine.IsEmpty then
            Error(Text001);

          WhseActivLine.SetCurrentkey("Whse. Document No.","Whse. Document Type","Activity Type");
          WhseActivLine.SetRange("Whse. Document No.","No.");
          WhseActivLine.SetRange("Whse. Document Type",WhseActivLine."whse. document type"::Shipment);
          WhseActivLine.SetRange("Activity Type",WhseActivLine."activity type"::Pick);
          if not WhseActivLine.IsEmpty then
            Error(Text002);

          WhsePickRqst.SetRange("Document Type",WhsePickRqst."document type"::Shipment);
          WhsePickRqst.SetRange("Document No.","No.");
          WhsePickRqst.SetRange(Status,Status::Released);
          if not WhsePickRqst.IsEmpty then
            WhsePickRqst.ModifyAll(Status,WhsePickRqst.Status::Open);

          Status := Status::Open;
          Modify;
        end;
    end;

    local procedure CreateWhsePickRqst(var WhseShptHeader: Record "Warehouse Shipment Header")
    var
        WhsePickRqst: Record "Whse. Pick Request";
        Location: Record Location;
    begin
        with WhseShptHeader do
          if Location.RequirePicking("Location Code") then begin
            WhsePickRqst."Document Type" := WhsePickRqst."document type"::Shipment;
            WhsePickRqst."Document No." := "No.";
            WhsePickRqst.Status := Status;
            WhsePickRqst."Location Code" := "Location Code";
            WhsePickRqst."Zone Code" := "Zone Code";
            WhsePickRqst."Bin Code" := "Bin Code";
            CalcFields("Completely Picked");
            WhsePickRqst."Completely Picked" := "Completely Picked";
            if not WhsePickRqst.Insert then
              WhsePickRqst.Modify;
          end;
    end;
}

