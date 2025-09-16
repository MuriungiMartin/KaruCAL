#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7315 "Whse. Internal Pick Release"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'There is nothing to release for %1 %2.';
        Text001: label 'You cannot reopen the whse. internal pick because warehouse worksheet lines exist that must first be handled or deleted.';
        Text002: label 'You cannot reopen the whse. internal pick because warehouse activity lines exist that must first be handled or deleted.';


    procedure Release(var WhsePickHeader: Record "Whse. Internal Pick Header")
    var
        Location: Record Location;
        WhsePickRqst: Record "Whse. Pick Request";
        WhsePickLine: Record "Whse. Internal Pick Line";
    begin
        with WhsePickHeader do begin
          if Status = Status::Released then
            exit;

          WhsePickLine.SetRange("No.","No.");
          WhsePickLine.SetFilter(Quantity,'<>0');
          if not WhsePickLine.Find('-') then
            Error(Text000,TableCaption,"No.");

          if "Location Code" <> '' then begin
            Location.Get("Location Code");
            Location.TestField("Require Pick");
          end else
            CheckPickRequired("Location Code");

          repeat
            WhsePickLine.TestField("Item No.");
            WhsePickLine.TestField("Unit of Measure Code");
            if Location."Directed Put-away and Pick" then
              WhsePickLine.TestField("To Zone Code");
            if Location."Bin Mandatory" then
              WhsePickLine.TestField("To Bin Code");
          until WhsePickLine.Next = 0;

          Status := Status::Released;
          Modify;

          CreateWhsePickRqst(WhsePickHeader);

          WhsePickRqst.SetRange("Document Type",WhsePickRqst."document type"::"Internal Pick");
          WhsePickRqst.SetRange("Document No.","No.");
          WhsePickRqst.SetRange(Status,Status::Open);
          if not WhsePickRqst.IsEmpty then
            WhsePickRqst.DeleteAll(true);

          Commit;
        end;
    end;


    procedure Reopen(WhsePickHeader: Record "Whse. Internal Pick Header")
    var
        WhsePickRqst: Record "Whse. Pick Request";
        PickWkshLine: Record "Whse. Worksheet Line";
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        with WhsePickHeader do begin
          if Status = Status::Open then
            exit;

          PickWkshLine.SetCurrentkey("Whse. Document Type","Whse. Document No.");
          PickWkshLine.SetRange("Whse. Document Type",PickWkshLine."whse. document type"::"Internal Pick");
          PickWkshLine.SetRange("Whse. Document No.","No.");
          if not PickWkshLine.IsEmpty then
            Error(Text001);

          WhseActivLine.SetCurrentkey("Whse. Document No.","Whse. Document Type","Activity Type");
          WhseActivLine.SetRange("Whse. Document No.","No.");
          WhseActivLine.SetRange("Whse. Document Type",WhseActivLine."whse. document type"::"Internal Pick");
          WhseActivLine.SetRange("Activity Type",WhseActivLine."activity type"::Pick);
          if not WhseActivLine.IsEmpty then
            Error(Text002);

          WhsePickRqst.SetRange("Document Type",WhsePickRqst."document type"::"Internal Pick");
          WhsePickRqst.SetRange("Document No.","No.");
          WhsePickRqst.SetRange(Status,Status::Released);
          if not WhsePickRqst.IsEmpty then
            WhsePickRqst.ModifyAll(Status,WhsePickRqst.Status::Open);

          Status := Status::Open;
          Modify;
        end;
    end;

    local procedure CreateWhsePickRqst(var WhsePickHeader: Record "Whse. Internal Pick Header")
    var
        WhsePickRqst: Record "Whse. Pick Request";
        Location: Record Location;
    begin
        with WhsePickHeader do
          if Location.RequirePicking("Location Code") then begin
            WhsePickRqst."Document Type" := WhsePickRqst."document type"::"Internal Pick";
            WhsePickRqst."Document No." := "No.";
            WhsePickRqst.Status := Status;
            WhsePickRqst."Location Code" := "Location Code";
            WhsePickRqst."Zone Code" := "To Zone Code";
            WhsePickRqst."Bin Code" := "To Bin Code";
            "Document Status" := GetDocumentStatus(0);
            WhsePickRqst."Completely Picked" :=
              "Document Status" = "document status"::"Completely Picked";
            if not WhsePickRqst.Insert then
              WhsePickRqst.Modify;
          end;
    end;
}

