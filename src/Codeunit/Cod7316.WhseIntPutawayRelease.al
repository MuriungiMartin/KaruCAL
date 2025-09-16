#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7316 "Whse. Int. Put-away Release"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'There is nothing to release for %1 %2.';
        Text001: label 'You cannot reopen the whse. internal put-away because warehouse worksheet lines exist that must first be handled or deleted.';
        Text002: label 'You cannot reopen the whse. internal put-away because warehouse activity lines exist that must first be handled or deleted.';


    procedure Release(WhseInternalPutAwayHeader: Record "Whse. Internal Put-away Header")
    var
        Location: Record Location;
        WhsePutawayRqst: Record "Whse. Put-away Request";
        WhseInternalPutawayLine: Record "Whse. Internal Put-away Line";
    begin
        with WhseInternalPutAwayHeader do begin
          if Status = Status::Released then
            exit;

          WhseInternalPutawayLine.SetRange("No.","No.");
          WhseInternalPutawayLine.SetFilter(Quantity,'<>0');
          if not WhseInternalPutawayLine.Find('-') then
            Error(Text000,TableCaption,"No.");

          if "Location Code" <> '' then begin
            Location.Get("Location Code");
            Location.TestField("Require Put-away");
          end else
            CheckPutawayRequired("Location Code");

          repeat
            WhseInternalPutawayLine.TestField("Item No.");
            WhseInternalPutawayLine.TestField("Unit of Measure Code");
            if Location."Directed Put-away and Pick" then
              WhseInternalPutawayLine.TestField("From Zone Code");
            if Location."Bin Mandatory" then
              WhseInternalPutawayLine.TestField("From Bin Code");
          until WhseInternalPutawayLine.Next = 0;

          Status := Status::Released;
          Modify;

          CreateWhsePutawayRqst(WhseInternalPutAwayHeader);

          WhsePutawayRqst.SetRange(
            "Document Type",WhsePutawayRqst."document type"::"Internal Put-away");
          WhsePutawayRqst.SetRange("Document No.","No.");
          WhsePutawayRqst.SetRange(Status,Status::Open);
          WhsePutawayRqst.DeleteAll(true);

          Commit;
        end;
    end;


    procedure Reopen(WhseInternalPutAwayHeader: Record "Whse. Internal Put-away Header")
    var
        WhsePutawayRqst: Record "Whse. Put-away Request";
        WhseWkshLine: Record "Whse. Worksheet Line";
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        with WhseInternalPutAwayHeader do begin
          if Status = Status::Open then
            exit;

          WhseWkshLine.SetCurrentkey("Whse. Document Type","Whse. Document No.");
          WhseWkshLine.SetRange("Whse. Document Type",WhseWkshLine."whse. document type"::"Internal Put-away");
          WhseWkshLine.SetRange("Whse. Document No.","No.");
          if not WhseWkshLine.IsEmpty then
            Error(Text001);

          WhseActivLine.SetCurrentkey("Whse. Document No.","Whse. Document Type","Activity Type");
          WhseActivLine.SetRange("Whse. Document No.","No.");
          WhseActivLine.SetRange("Whse. Document Type",WhseActivLine."whse. document type"::"Internal Put-away");
          WhseActivLine.SetRange("Activity Type",WhseActivLine."activity type"::"Put-away");
          if not WhseActivLine.IsEmpty then
            Error(Text002);

          WhsePutawayRqst.SetRange("Document Type",WhsePutawayRqst."document type"::"Internal Put-away");
          WhsePutawayRqst.SetRange("Document No.","No.");
          WhsePutawayRqst.SetRange(Status,Status::Released);
          if WhsePutawayRqst.Find('-') then
            repeat
              WhsePutawayRqst.Status := Status::Open;
              WhsePutawayRqst.Modify;
            until WhsePutawayRqst.Next = 0;

          Status := Status::Open;
          Modify;
        end;
    end;

    local procedure CreateWhsePutawayRqst(var WhseInternalPutAwayHeader: Record "Whse. Internal Put-away Header")
    var
        WhsePutawayRqst: Record "Whse. Put-away Request";
    begin
        with WhseInternalPutAwayHeader do begin
          WhsePutawayRqst."Document Type" := WhsePutawayRqst."document type"::"Internal Put-away";
          WhsePutawayRqst."Document No." := "No.";
          WhsePutawayRqst.Status := Status;
          WhsePutawayRqst."Location Code" := "Location Code";
          WhsePutawayRqst."Zone Code" := "From Zone Code";
          WhsePutawayRqst."Bin Code" := "From Bin Code";
          "Document Status" := GetDocumentStatus(0);
          WhsePutawayRqst."Completely Put Away" :=
            "Document Status" = "document status"::"Completely Put Away";
          if not WhsePutawayRqst.Insert then
            WhsePutawayRqst.Modify;
        end;
    end;
}

