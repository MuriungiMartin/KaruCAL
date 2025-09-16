#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7320 "Whse. Undo Quantity"
{
    Permissions = TableData "Whse. Item Entry Relation"=md,
                  TableData "Posted Whse. Shipment Line"=rimd;
    TableNo = "Item Journal Line";

    trigger OnRun()
    begin
    end;

    var
        WMSMgmt: Codeunit "WMS Management";
        Text000: label 'Assertion failed, %1.';
        Text001: label 'There is not enough space to insert correction lines.';


    procedure InsertTempWhseJnlLine(ItemJnlLine: Record "Item Journal Line";SourceType: Integer;SourceSubType: Integer;SourceNo: Code[20];SourceLineNo: Integer;RefDoc: Integer;var TempWhseJnlLine: Record "Warehouse Journal Line" temporary;var NextLineNo: Integer)
    var
        WhseEntry: Record "Warehouse Entry";
        WhseMgt: Codeunit "Whse. Management";
    begin
        with ItemJnlLine do begin
          WhseEntry.Reset;
          WhseEntry.SetCurrentkey("Source Type","Source Subtype","Source No.");
          WhseEntry.SetRange("Source Type",SourceType);
          WhseEntry.SetRange("Source Subtype",SourceSubType);
          WhseEntry.SetRange("Source No.",SourceNo);
          WhseEntry.SetRange("Source Line No.",SourceLineNo);
          WhseEntry.SetRange("Reference No.","Document No.");
          WhseEntry.SetRange("Item No.","Item No.");
          if WhseEntry.Find('+') then
            repeat
              TempWhseJnlLine.Init;
              if WhseEntry."Entry Type" = WhseEntry."entry type"::"Positive Adjmt." then
                "Entry Type" := "entry type"::"Negative Adjmt."
              else
                "Entry Type" := "entry type"::"Positive Adjmt.";
              Quantity := Abs(WhseEntry.Quantity);
              "Quantity (Base)" := Abs(WhseEntry."Qty. (Base)");
              WMSMgmt.CreateWhseJnlLine(ItemJnlLine,0,TempWhseJnlLine,false);
              TempWhseJnlLine."Source Type" := SourceType;
              TempWhseJnlLine."Source Subtype" := SourceSubType;
              TempWhseJnlLine."Source No." := SourceNo;
              TempWhseJnlLine."Source Line No." := SourceLineNo;
              TempWhseJnlLine."Source Document" :=
                WhseMgt.GetSourceDocument(TempWhseJnlLine."Source Type",TempWhseJnlLine."Source Subtype");
              TempWhseJnlLine."Reference Document" := RefDoc;
              TempWhseJnlLine."Reference No." := "Document No.";
              TempWhseJnlLine."Location Code" := "Location Code";
              TempWhseJnlLine."Zone Code" := WhseEntry."Zone Code";
              TempWhseJnlLine."Bin Code" := WhseEntry."Bin Code";
              TempWhseJnlLine."Whse. Document Type" := WhseEntry."Whse. Document Type";
              TempWhseJnlLine."Whse. Document No." := WhseEntry."Whse. Document No.";
              TempWhseJnlLine."Unit of Measure Code" := WhseEntry."Unit of Measure Code";
              TempWhseJnlLine."Line No." := NextLineNo;
              TempWhseJnlLine."Serial No." := WhseEntry."Serial No.";
              TempWhseJnlLine."Lot No." := WhseEntry."Lot No.";
              TempWhseJnlLine."Expiration Date" := WhseEntry."Expiration Date";
              if  "Entry Type" = "entry type"::"Negative Adjmt." then begin
                TempWhseJnlLine."From Zone Code" := TempWhseJnlLine."Zone Code";
                TempWhseJnlLine."From Bin Code" := TempWhseJnlLine."Bin Code";
              end else begin
                TempWhseJnlLine."To Zone Code" := TempWhseJnlLine."Zone Code";
                TempWhseJnlLine."To Bin Code" := TempWhseJnlLine."Bin Code";
              end;
              TempWhseJnlLine.Insert;
              NextLineNo := TempWhseJnlLine."Line No." + 10000;
            until WhseEntry.Next(-1) = 0;
        end;
    end;


    procedure PostTempWhseJnlLine(var TempWhseJnlLine: Record "Warehouse Journal Line" temporary)
    begin
        if TempWhseJnlLine.Find('-') then
          repeat
            Codeunit.Run(Codeunit::"Whse. Jnl.-Register Line",TempWhseJnlLine);
          until TempWhseJnlLine.Next = 0;
    end;


    procedure UndoPostedWhseRcptLine(var PostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    begin
        PostedWhseRcptLine.TestField("Source Type");
        InsertPostedWhseRcptLine(PostedWhseRcptLine);
        DeleteWhsePutAwayRequest(PostedWhseRcptLine);
        DeleteWhseItemEntryRelationRcpt(PostedWhseRcptLine);
    end;


    procedure UndoPostedWhseShptLine(var PostedWhseShptLine: Record "Posted Whse. Shipment Line")
    begin
        PostedWhseShptLine.TestField("Source Type");
        InsertPostedWhseShptLine(PostedWhseShptLine);
        DeleteWhsePickRequest(PostedWhseShptLine);
        DeleteWhseItemEntryRelationShpt(PostedWhseShptLine);
    end;


    procedure UpdateRcptSourceDocLines(var PostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    begin
        UpdateWhseRcptLine(PostedWhseRcptLine);
        UpdateWhseRequestRcpt(PostedWhseRcptLine);
    end;


    procedure UpdateShptSourceDocLines(var PostedWhseShptLine: Record "Posted Whse. Shipment Line")
    begin
        UpdateWhseShptLine(PostedWhseShptLine);
        UpdateWhseRequestShpt(PostedWhseShptLine);
    end;


    procedure FindPostedWhseRcptLine(var PostedWhseRcptLine: Record "Posted Whse. Receipt Line";UndoType: Integer;UndoID: Code[20];SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer) Ok: Boolean
    begin
        with PostedWhseRcptLine do begin
          Clear(PostedWhseRcptLine);
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          case UndoType of
            Database::"Purch. Rcpt. Line":
              SetRange("Posted Source Document","posted source document"::"Posted Receipt");
            Database::"Return Receipt Line":
              SetRange("Posted Source Document","posted source document"::"Posted Return Receipt");
            else
              exit;
          end;
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          SetRange("Posted Source No.",UndoID);
          if FindFirst then begin
            if Count > 1 then
              Error(Text000,TableCaption); // Assert: only one posted line.
            Ok := true;
          end;
        end;
    end;


    procedure FindPostedWhseShptLine(var PostedWhseShptLine: Record "Posted Whse. Shipment Line";UndoType: Integer;UndoID: Code[20];SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer) Ok: Boolean
    var
        PostedWhseShptLine2: Record "Posted Whse. Shipment Line";
    begin
        with PostedWhseShptLine do begin
          Clear(PostedWhseShptLine);
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          case UndoType of
            Database::"Sales Shipment Line",
            Database::"Service Shipment Line":
              SetRange("Posted Source Document","posted source document"::"Posted Shipment");
            Database::"Return Shipment Line":
              SetRange("Posted Source Document","posted source document"::"Posted Return Shipment");
            else
              exit;
          end;
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          SetRange("Posted Source No.",UndoID);

          if FindFirst then begin
            PostedWhseShptLine2.CopyFilters(PostedWhseShptLine);
            PostedWhseShptLine2.SetFilter("No.",'<>%1',"No.");
            PostedWhseShptLine2.SetFilter("Line No.",'<>%1',"Line No.");
            if not PostedWhseShptLine2.IsEmpty and not IsATO(UndoType,UndoID,SourceRefNo) then
              Error(Text000,TableCaption); // Assert: only one posted line.
            Ok := true;
          end;
        end;
    end;

    local procedure InsertPostedWhseRcptLine(OldPostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    var
        NewPostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        LineSpacing: Integer;
    begin
        with OldPostedWhseRcptLine do begin
          "Qty. Put Away" := Quantity;
          "Qty. Put Away (Base)" := "Qty. (Base)";
          Modify;

          NewPostedWhseRcptLine.SetRange("No.","No.");
          NewPostedWhseRcptLine."No." := "No.";
          NewPostedWhseRcptLine."Line No." := "Line No.";
          NewPostedWhseRcptLine.Find('=');

          if NewPostedWhseRcptLine.Find('>') then begin
            LineSpacing := (NewPostedWhseRcptLine."Line No." - "Line No.") DIV 2;
            if LineSpacing = 0 then
              Error(Text001);
          end else
            LineSpacing := 10000;

          NewPostedWhseRcptLine.Reset;
          NewPostedWhseRcptLine.Init;
          NewPostedWhseRcptLine.Copy(OldPostedWhseRcptLine);
          NewPostedWhseRcptLine."Line No." := "Line No." + LineSpacing;
          NewPostedWhseRcptLine.Quantity := -Quantity;
          NewPostedWhseRcptLine."Qty. (Base)" := -"Qty. (Base)";
          NewPostedWhseRcptLine."Qty. Put Away" := -"Qty. Put Away";
          NewPostedWhseRcptLine."Qty. Put Away (Base)" := -"Qty. Put Away (Base)";
          NewPostedWhseRcptLine.Status := NewPostedWhseRcptLine.Status::"Completely Put Away";
          NewPostedWhseRcptLine.Insert;

          Status := Status::"Completely Put Away";
          Modify;
        end;
    end;

    local procedure InsertPostedWhseShptLine(OldPostedWhseShptLine: Record "Posted Whse. Shipment Line")
    var
        NewPostedWhseShptLine: Record "Posted Whse. Shipment Line";
        LineSpacing: Integer;
    begin
        with OldPostedWhseShptLine do begin
          NewPostedWhseShptLine.SetRange("No.","No.");
          NewPostedWhseShptLine."No." := "No.";
          NewPostedWhseShptLine."Line No." := "Line No.";
          NewPostedWhseShptLine.Find('=');

          if NewPostedWhseShptLine.Find('>') then begin
            LineSpacing := (NewPostedWhseShptLine."Line No." - "Line No.") DIV 2;
            if LineSpacing = 0 then
              Error(Text001);
          end else
            LineSpacing := 10000;

          NewPostedWhseShptLine.Reset;
          NewPostedWhseShptLine.Init;
          NewPostedWhseShptLine.Copy(OldPostedWhseShptLine);
          NewPostedWhseShptLine."Line No." := "Line No." + LineSpacing;
          NewPostedWhseShptLine.Quantity := -Quantity;
          NewPostedWhseShptLine."Qty. (Base)" := -"Qty. (Base)";
          NewPostedWhseShptLine.Insert;
        end;
    end;

    local procedure DeleteWhsePutAwayRequest(var PostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    var
        PostedWhseRcptLine2: Record "Posted Whse. Receipt Line";
        WhsePutAwayRequest: Record "Whse. Put-away Request";
        "Sum": Decimal;
    begin
        PostedWhseRcptLine2.SetRange("No.",PostedWhseRcptLine."No.");
        if PostedWhseRcptLine2.Find('-') then begin
          repeat
            Sum := Sum + PostedWhseRcptLine2."Qty. (Base)";
          until PostedWhseRcptLine2.Next = 0;

          if Sum = 0 then begin
            WhsePutAwayRequest.SetRange("Document Type",WhsePutAwayRequest."document type"::Receipt);
            WhsePutAwayRequest.SetRange("Document No.",PostedWhseRcptLine."No.");
            WhsePutAwayRequest.DeleteAll;
          end;
        end;
    end;

    local procedure DeleteWhsePickRequest(var PostedWhseShptLine: Record "Posted Whse. Shipment Line")
    var
        PostedWhseShptLine2: Record "Posted Whse. Shipment Line";
        WhsePickRequest: Record "Whse. Pick Request";
        "Sum": Decimal;
    begin
        PostedWhseShptLine2.SetRange("No.",PostedWhseShptLine."No.");
        if PostedWhseShptLine2.Find('-') then begin
          repeat
            Sum := Sum + PostedWhseShptLine2."Qty. (Base)";
          until PostedWhseShptLine2.Next = 0;

          if Sum = 0 then begin
            WhsePickRequest.SetRange("Document Type",WhsePickRequest."document type"::Shipment);
            WhsePickRequest.SetRange("Document No.",PostedWhseShptLine."No.");
            if not WhsePickRequest.IsEmpty then
              WhsePickRequest.DeleteAll;
          end;
        end;
    end;

    local procedure UpdateWhseRcptLine(var PostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    var
        WhseRcptHeader: Record "Warehouse Receipt Header";
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        with PostedWhseRcptLine do begin
          WhseRcptLine.SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          WhseRcptLine.SetRange("Source Type","Source Type");
          WhseRcptLine.SetRange("Source Subtype","Source Subtype");
          WhseRcptLine.SetRange("Source No.","Source No.");
          WhseRcptLine.SetRange("Source Line No.","Source Line No.");
          if WhseRcptLine.FindFirst then begin
            WhseRcptLine.Validate("Qty. Outstanding",WhseRcptLine."Qty. Outstanding" + Quantity);
            WhseRcptLine.Validate("Qty. Received",WhseRcptLine."Qty. Received" - Quantity);

            if WhseRcptLine."Qty. Received" = 0 then begin
              WhseRcptLine.Status := WhseRcptLine.Status::" ";
              WhseRcptHeader.Get(WhseRcptLine."No.");
              WhseRcptHeader."Document Status" := WhseRcptHeader."document status"::" ";
              WhseRcptHeader.Modify;
            end;
            WhseRcptLine.Modify;
          end;
        end;
    end;

    local procedure UpdateWhseShptLine(var PostedWhseShptLine: Record "Posted Whse. Shipment Line")
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        with PostedWhseShptLine do begin
          WhseShptLine.SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          WhseShptLine.SetRange("Source Type","Source Type");
          WhseShptLine.SetRange("Source Subtype","Source Subtype");
          WhseShptLine.SetRange("Source No.","Source No.");
          WhseShptLine.SetRange("Source Line No.","Source Line No.");
          if WhseShptLine.FindFirst then begin
            WhseShptLine.Validate("Qty. Shipped",WhseShptLine."Qty. Shipped" - Quantity);
            WhseShptLine.Validate("Qty. Outstanding",WhseShptLine."Qty. Outstanding" + Quantity);

            if WhseShptLine."Qty. Shipped" = 0 then begin
              WhseShptLine.Status := WhseShptLine.Status::" ";
              WhseShptHeader.Get(WhseShptLine."No.");
              WhseShptHeader."Document Status" := WhseShptHeader."document status"::" ";
              WhseShptHeader.Modify;
            end;
            WhseShptLine.Modify;
          end;
        end;
    end;

    local procedure DeleteWhseItemEntryRelationRcpt(NewPostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    begin
        with NewPostedWhseRcptLine do
          DeleteWhseItemEntryRelation(Database::"Posted Whse. Receipt Line","No.","Line No.");
    end;

    local procedure DeleteWhseItemEntryRelationShpt(NewPostedWhseShptLine: Record "Posted Whse. Shipment Line")
    begin
        with NewPostedWhseShptLine do
          DeleteWhseItemEntryRelation(Database::"Posted Whse. Shipment Line","No.","Line No.");
    end;

    local procedure DeleteWhseItemEntryRelation(SourceType: Integer;SourceNo: Code[20];SourceLineNo: Integer)
    var
        WhseItemEntryRelation: Record "Whse. Item Entry Relation";
    begin
        WhseItemEntryRelation.SetCurrentkey(
          "Source ID","Source Type","Source Subtype","Source Ref. No.");
        WhseItemEntryRelation.SetRange("Source Type",SourceType);
        WhseItemEntryRelation.SetRange("Source Subtype",0);
        WhseItemEntryRelation.SetRange("Source ID",SourceNo);
        WhseItemEntryRelation.SetRange("Source Ref. No.",SourceLineNo);
        WhseItemEntryRelation.DeleteAll;
    end;

    local procedure UpdateWhseRequestRcpt(var PostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    var
        PurchLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
    begin
        with PostedWhseRcptLine do begin
          case "Source Type" of
            Database::"Purchase Line":
              begin
                PurchLine.Get("Source Subtype","Source No.","Source Line No.");
                if not (PurchLine."Quantity Received" < PurchLine.Quantity) then
                  exit;
              end;
            Database::"Sales Line":
              begin
                SalesLine.Get("Source Subtype","Source No.","Source Line No.");
                if not (SalesLine."Return Qty. Received" < SalesLine.Quantity) then
                  exit;
              end;
          end;
          UpdateWhseRequest("Source Type","Source Subtype","Source No.");
        end;
    end;

    local procedure UpdateWhseRequestShpt(var PostedWhseShptLine: Record "Posted Whse. Shipment Line")
    var
        PurchLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
    begin
        with PostedWhseShptLine do begin
          case "Source Type" of
            Database::"Sales Line":
              begin
                SalesLine.Get("Source Subtype","Source No.","Source Line No.");
                if not (SalesLine."Quantity Shipped" < SalesLine.Quantity) then
                  exit;
              end;
            Database::"Purchase Line":
              begin
                PurchLine.Get("Source Subtype","Source No.","Source Line No.");
                if not (PurchLine."Return Qty. Shipped" < PurchLine.Quantity) then
                  exit;
              end;
          end;
          UpdateWhseRequest("Source Type","Source Subtype","Source No.");
        end;
    end;

    local procedure UpdateWhseRequest(SourceType: Integer;SourceSubType: Integer;SourceNo: Code[20])
    var
        WhseRequest: Record "Warehouse Request";
    begin
        with WhseRequest do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubType);
          SetRange("Source No.",SourceNo);
          if FindFirst and "Completely Handled" then begin
            "Completely Handled" := false;
            Modify;
          end;
        end;
    end;

    local procedure IsATO(UndoType: Integer;UndoID: Code[20];SourceRefNo: Integer): Boolean
    var
        PostedATOLink: Record "Posted Assemble-to-Order Link";
    begin
        if UndoType = Database::"Sales Shipment Line" then begin
          PostedATOLink.SetRange("Document Type",PostedATOLink."document type"::"Sales Shipment");
          PostedATOLink.SetRange("Document No.",UndoID);
          PostedATOLink.SetRange("Document Line No.",SourceRefNo);
          exit(not PostedATOLink.IsEmpty);
        end;
    end;
}

