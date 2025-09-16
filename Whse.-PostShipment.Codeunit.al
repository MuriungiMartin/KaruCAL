#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5763 "Whse.-Post Shipment"
{
    Permissions = TableData "Whse. Item Tracking Line"=r,
                  TableData "Posted Whse. Shipment Header"=im,
                  TableData "Posted Whse. Shipment Line"=i;
    TableNo = "Warehouse Shipment Line";

    trigger OnRun()
    begin
        WhseShptLine.Copy(Rec);
        Code;
        Rec := WhseShptLine;
    end;

    var
        Text000: label 'The source document %1 %2 is not released.';
        Text001: label 'There is nothing to post.';
        Text003: label 'Number of source documents posted: %1 out of a total of %2.';
        Text004: label 'Ship lines have been posted.';
        Text005: label 'Some ship lines remain.';
        WhseRqst: Record "Warehouse Request";
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseShptLineBuf: Record "Warehouse Shipment Line" temporary;
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        TransHeader: Record "Transfer Header";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        ReturnShptHeader: Record "Return Shipment Header";
        PurchCrMemHeader: Record "Purch. Cr. Memo Hdr.";
        TransShptHeader: Record "Transfer Shipment Header";
        Location: Record Location;
        ServiceHeader: Record "Service Header";
        ServiceShptHeader: Record "Service Shipment Header";
        ServiceInvHeader: Record "Service Invoice Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line";
        WMSMgt: Codeunit "WMS Management";
        LastShptNo: Code[20];
        PostingDate: Date;
        CounterSourceDocOK: Integer;
        CounterSourceDocTotal: Integer;
        Print: Boolean;
        Invoice: Boolean;
        Text006: label '%1, %2 %3: you cannot ship more than have been picked for the item tracking lines.';
        Text007: label 'is not within your range of allowed posting dates';
        InvoiceService: Boolean;
        FullATONotPostedErr: label 'Warehouse shipment %1, Line No. %2 cannot be posted, because the full assemble-to-order quantity on the source document line must be shipped first.';

    local procedure "Code"()
    begin
        with WhseShptLine do begin
          SetCurrentkey("No.");
          SetRange("No.","No.");
          SetFilter("Qty. to Ship",'>0');
          if Find('-') then
            repeat
              TestField("Unit of Measure Code");
              if "Shipping Advice" = "shipping advice"::Complete then
                TestField("Qty. (Base)","Qty. to Ship (Base)" + "Qty. Shipped (Base)");
              WhseRqst.Get(
                WhseRqst.Type::Outbound,"Location Code","Source Type","Source Subtype","Source No.");
              if WhseRqst."Document Status" <> WhseRqst."document status"::Released then
                Error(Text000,"Source Document","Source No.");
              GetLocation("Location Code");
              if Location."Require Pick" and ("Shipping Advice" = "shipping advice"::Complete) then
                CheckItemTrkgPicked(WhseShptLine);
              if Location."Bin Mandatory" then
                TestField("Bin Code");
              if not "Assemble to Order" then
                if not FullATOPosted then
                  Error(FullATONotPostedErr,"No.","Line No.");
            until Next = 0
          else
            Error(Text001);

          CounterSourceDocOK := 0;
          CounterSourceDocTotal := 0;

          GetLocation("Location Code");
          WhseShptHeader.Get("No.");
          WhseShptHeader.TestField("Posting Date");
          if WhseShptHeader."Shipping No." = '' then begin
            WhseShptHeader.TestField("Shipping No. Series");
            WhseShptHeader."Shipping No." :=
              NoSeriesMgt.GetNextNo(
                WhseShptHeader."Shipping No. Series",WhseShptHeader."Posting Date",true);
          end;
          WhseShptHeader."Create Posted Header" := true;
          WhseShptHeader.Modify;
          Commit;

          SetCurrentkey("No.","Source Type","Source Subtype","Source No.","Source Line No.");
          FindSet(true,true);
          repeat
            SetRange("Source Type","Source Type");
            SetRange("Source Subtype","Source Subtype");
            SetRange("Source No.","Source No.");
            GetSourceDocument;
            MakePreliminaryChecks;

            InitSourceDocumentLines(WhseShptLine);
            InitSourceDocumentHeader;
            Commit;

            CounterSourceDocTotal := CounterSourceDocTotal + 1;
            PostSourceDocument(WhseShptLine);

            if FindLast then;
            SetRange("Source Type");
            SetRange("Source Subtype");
            SetRange("Source No.");
          until Next = 0;
        end;

        Clear(WMSMgt);
        Clear(WhseJnlRegisterLine);

        WhseShptLine.Reset;
    end;

    local procedure GetSourceDocument()
    begin
        with WhseShptLine do
          case "Source Type" of
            Database::"Sales Line":
              SalesHeader.Get("Source Subtype","Source No.");
            Database::"Purchase Line": // Return Order
              PurchHeader.Get("Source Subtype","Source No.");
            Database::"Transfer Line":
              TransHeader.Get("Source No.");
            Database::"Service Line":
              ServiceHeader.Get("Source Subtype","Source No.");
          end;
    end;

    local procedure MakePreliminaryChecks()
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin
        with WhseShptHeader do begin
          if GenJnlCheckLine.DateNotAllowed("Posting Date") then
            FieldError("Posting Date",Text007);
        end;
    end;

    local procedure InitSourceDocumentHeader()
    var
        SalesRelease: Codeunit "Release Sales Document";
        PurchRelease: Codeunit "Release Purchase Document";
        ReleaseServiceDocument: Codeunit "Release Service Document";
        ModifyHeader: Boolean;
    begin
        with WhseShptLine do
          case "Source Type" of
            Database::"Sales Line":
              begin
                if (SalesHeader."Posting Date" = 0D) or
                   (SalesHeader."Posting Date" <> WhseShptHeader."Posting Date")
                then begin
                  SalesRelease.Reopen(SalesHeader);
                  SalesHeader.SetHideValidationDialog(true);
                  SalesHeader.Validate("Posting Date",WhseShptHeader."Posting Date");
                  SalesRelease.Run(SalesHeader);
                  ModifyHeader := true;
                end;
                if (WhseShptHeader."Shipment Date" <> 0D) and
                   (WhseShptHeader."Shipment Date" <> SalesHeader."Shipment Date")
                then begin
                  SalesHeader."Shipment Date" := WhseShptHeader."Shipment Date";
                  ModifyHeader := true;
                end;
                if (WhseShptHeader."External Document No." <> '') and
                   (WhseShptHeader."External Document No." <> SalesHeader."External Document No.")
                then begin
                  SalesHeader."External Document No." := WhseShptHeader."External Document No.";
                  ModifyHeader := true;
                end;
                if (WhseShptHeader."Shipping Agent Code" <> '') and
                   (WhseShptHeader."Shipping Agent Code" <> SalesHeader."Shipping Agent Code")
                then begin
                  SalesHeader."Shipping Agent Code" := WhseShptHeader."Shipping Agent Code";
                  SalesHeader."Shipping Agent Service Code" := WhseShptHeader."Shipping Agent Service Code";
                  ModifyHeader := true;
                end;
                if (WhseShptHeader."Shipping Agent Service Code" <> '') and
                   (WhseShptHeader."Shipping Agent Service Code" <>
                    SalesHeader."Shipping Agent Service Code")
                then begin
                  SalesHeader."Shipping Agent Service Code" :=
                    WhseShptHeader."Shipping Agent Service Code";
                  ModifyHeader := true;
                end;
                if (WhseShptHeader."Shipment Method Code" <> '') and
                   (WhseShptHeader."Shipment Method Code" <> SalesHeader."Shipment Method Code")
                then begin
                  SalesHeader."Shipment Method Code" := WhseShptHeader."Shipment Method Code";
                  ModifyHeader := true;
                end;
                if ModifyHeader then
                  SalesHeader.Modify;
              end;
            Database::"Purchase Line": // Return Order
              begin
                if (PurchHeader."Posting Date" = 0D) or
                   (PurchHeader."Posting Date" <> WhseShptHeader."Posting Date")
                then begin
                  PurchRelease.Reopen(PurchHeader);
                  PurchHeader.SetHideValidationDialog(true);
                  PurchHeader.Validate("Posting Date",WhseShptHeader."Posting Date");
                  PurchRelease.Run(PurchHeader);
                  ModifyHeader := true;
                end;
                if (WhseShptHeader."Shipment Date" <> 0D) and
                   (WhseShptHeader."Shipment Date" <> PurchHeader."Expected Receipt Date")
                then begin
                  PurchHeader."Expected Receipt Date" := WhseShptHeader."Shipment Date";
                  ModifyHeader := true;
                end;
                if WhseShptHeader."External Document No." <> '' then begin
                  PurchHeader."Vendor Authorization No." := WhseShptHeader."External Document No.";
                  ModifyHeader := true;
                end;
                if (WhseShptHeader."Shipment Method Code" <> '') and
                   (WhseShptHeader."Shipment Method Code" <> PurchHeader."Shipment Method Code")
                then begin
                  PurchHeader."Shipment Method Code" := WhseShptHeader."Shipment Method Code";
                  ModifyHeader := true;
                end;
                if ModifyHeader then
                  PurchHeader.Modify;
              end;
            Database::"Transfer Line":
              begin
                if (TransHeader."Posting Date" = 0D) or
                   (TransHeader."Posting Date" <> WhseShptHeader."Posting Date")
                then begin
                  TransHeader.CalledFromWarehouse(true);
                  TransHeader.Validate("Posting Date",WhseShptHeader."Posting Date");
                  ModifyHeader := true;
                end;
                if (WhseShptHeader."Shipment Date" <> 0D) and
                   (TransHeader."Shipment Date" <> WhseShptHeader."Shipment Date")
                then begin
                  TransHeader."Shipment Date" := WhseShptHeader."Shipment Date";
                  ModifyHeader := true;
                end;
                if WhseShptHeader."External Document No." <> '' then begin
                  TransHeader."External Document No." := WhseShptHeader."External Document No.";
                  ModifyHeader := true;
                end;
                if (WhseShptHeader."Shipping Agent Code" <> '') and
                   (WhseShptHeader."Shipping Agent Code" <> TransHeader."Shipping Agent Code")
                then begin
                  TransHeader."Shipping Agent Code" := WhseShptHeader."Shipping Agent Code";
                  ModifyHeader := true;
                end;
                if (WhseShptHeader."Shipping Agent Service Code" <> '') and
                   (WhseShptHeader."Shipping Agent Service Code" <>
                    TransHeader."Shipping Agent Service Code")
                then begin
                  TransHeader."Shipping Agent Service Code" :=
                    WhseShptHeader."Shipping Agent Service Code";
                  ModifyHeader := true;
                end;
                if (WhseShptHeader."Shipment Method Code" <> '') and
                   (WhseShptHeader."Shipment Method Code" <> TransHeader."Shipment Method Code")
                then begin
                  TransHeader."Shipment Method Code" := WhseShptHeader."Shipment Method Code";
                  ModifyHeader := true;
                end;
                if ModifyHeader then
                  TransHeader.Modify;
              end;
            Database::"Service Line":
              begin
                if (ServiceHeader."Posting Date" = 0D) or (ServiceHeader."Posting Date" <> WhseShptHeader."Posting Date") then begin
                  ReleaseServiceDocument.Reopen(ServiceHeader);
                  ServiceHeader.SetHideValidationDialog(true);
                  ServiceHeader.Validate("Posting Date",WhseShptHeader."Posting Date");
                  ReleaseServiceDocument.Run(ServiceHeader);
                  ServiceHeader.Modify;
                end;
                if ModifyIfDifferent(ServiceHeader."Shipping Agent Code",WhseShptHeader."Shipping Agent Code") or
                   ModifyIfDifferent(ServiceHeader."Shipping Agent Service Code",WhseShptHeader."Shipping Agent Service Code") or
                   ModifyIfDifferent(ServiceHeader."Shipment Method Code",WhseShptHeader."Shipment Method Code")
                then
                  ServiceHeader.Modify;
              end;
          end;
    end;

    local procedure InitSourceDocumentLines(var WhseShptLine: Record "Warehouse Shipment Line")
    var
        WhseShptLine2: Record "Warehouse Shipment Line";
    begin
        WhseShptLine2.Copy(WhseShptLine);
        case WhseShptLine2."Source Type" of
          Database::"Sales Line":
            HandleSalesLine(WhseShptLine2);
          Database::"Purchase Line": // Return Order
            HandlePurchaseLine(WhseShptLine2);
          Database::"Transfer Line":
            HandleTransferLine(WhseShptLine2);
          Database::"Service Line":
            HandleServiceLine(WhseShptLine2);
        end;
        WhseShptLine2.SetRange("Source Line No.");
    end;

    local procedure PostSourceDocument(WhseShptLine: Record "Warehouse Shipment Line")
    var
        WhseSetup: Record "Warehouse Setup";
        WhseShptHeader: Record "Warehouse Shipment Header";
        SalesPost: Codeunit "Sales-Post";
        PurchPost: Codeunit "Purch.-Post";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        ServicePost: Codeunit "Service-Post";
    begin
        WhseSetup.Get;
        with WhseShptLine do begin
          WhseShptHeader.Get("No.");
          case "Source Type" of
            Database::"Sales Line":
              begin
                if "Source Document" = "source document"::"Sales Order" then
                  SalesHeader.Ship := true
                else
                  SalesHeader.Receive := true;
                SalesHeader.Invoice := Invoice;

                SalesPost.SetWhseShptHeader(WhseShptHeader);
                case WhseSetup."Shipment Posting Policy" of
                  WhseSetup."shipment posting policy"::"Posting errors are not processed":
                    begin
                      if SalesPost.Run(SalesHeader) then
                        CounterSourceDocOK := CounterSourceDocOK + 1;
                    end;
                  WhseSetup."shipment posting policy"::"Stop and show the first posting error":
                    begin
                      SalesPost.Run(SalesHeader);
                      CounterSourceDocOK := CounterSourceDocOK + 1;
                    end;
                end;

                if Print then
                  if "Source Document" = "source document"::"Sales Order" then begin
                    SalesShptHeader."No." := SalesHeader."Last Shipping No.";
                    SalesShptHeader.SetRecfilter;
                    SalesShptHeader.PrintRecords(false);
                    if Invoice then begin
                      SalesInvHeader."No." := SalesHeader."Last Posting No.";
                      SalesInvHeader.SetRecfilter;
                      SalesInvHeader.PrintRecords(false);
                    end;
                  end;
                Clear(SalesPost);
              end;
            Database::"Purchase Line": // Return Order
              begin
                if "Source Document" = "source document"::"Purchase Order" then
                  PurchHeader.Receive := true
                else
                  PurchHeader.Ship := true;
                PurchHeader.Invoice := Invoice;

                PurchPost.SetWhseShptHeader(WhseShptHeader);
                case WhseSetup."Shipment Posting Policy" of
                  WhseSetup."shipment posting policy"::"Posting errors are not processed":
                    begin
                      if PurchPost.Run(PurchHeader) then
                        CounterSourceDocOK := CounterSourceDocOK + 1;
                    end;
                  WhseSetup."shipment posting policy"::"Stop and show the first posting error":
                    begin
                      PurchPost.Run(PurchHeader);
                      CounterSourceDocOK := CounterSourceDocOK + 1;
                    end;
                end;

                if Print then
                  if "Source Document" = "source document"::"Purchase Return Order" then begin
                    ReturnShptHeader."No." := PurchHeader."Last Return Shipment No.";
                    ReturnShptHeader.SetRecfilter;
                    ReturnShptHeader.PrintRecords(false);
                    if Invoice then begin
                      PurchCrMemHeader."No." := PurchHeader."Last Posting No.";
                      PurchCrMemHeader.SetRecfilter;
                      PurchCrMemHeader.PrintRecords(false);
                    end;
                  end;
                Clear(PurchPost);
              end;
            Database::"Transfer Line":
              begin
                TransferPostShipment.SetWhseShptHeader(WhseShptHeader);
                case WhseSetup."Shipment Posting Policy" of
                  WhseSetup."shipment posting policy"::"Posting errors are not processed":
                    begin
                      if TransferPostShipment.Run(TransHeader) then
                        CounterSourceDocOK := CounterSourceDocOK + 1;
                    end;
                  WhseSetup."shipment posting policy"::"Stop and show the first posting error":
                    begin
                      TransferPostShipment.Run(TransHeader);
                      CounterSourceDocOK := CounterSourceDocOK + 1;
                    end;
                end;

                if Print then begin
                  TransShptHeader."No." := TransHeader."Last Shipment No.";
                  TransShptHeader.SetRecfilter;
                  TransShptHeader.PrintRecords(false);
                end;
                Clear(TransferPostShipment);
              end;
            Database::"Service Line":
              begin
                ServicePost.SetPostingOptions(true,false,InvoiceService);
                case WhseSetup."Shipment Posting Policy" of
                  WhseSetup."shipment posting policy"::"Posting errors are not processed":
                    begin
                      if ServicePost.Run(ServiceHeader) then
                        CounterSourceDocOK := CounterSourceDocOK + 1;
                    end;
                  WhseSetup."shipment posting policy"::"Stop and show the first posting error":
                    begin
                      ServicePost.Run(ServiceHeader);
                      CounterSourceDocOK := CounterSourceDocOK + 1;
                    end;
                end;
                if Print then
                  if "Source Document" = "source document"::"Service Order" then begin
                    ServiceShptHeader."No." := ServiceHeader."Last Shipping No.";
                    ServiceShptHeader.SetRecfilter;
                    ServiceShptHeader.PrintRecords(false);
                    if Invoice then begin
                      ServiceInvHeader."No." := ServiceHeader."Last Posting No.";
                      ServiceInvHeader.SetRecfilter;
                      ServiceInvHeader.PrintRecords(false);
                    end;
                  end;
                Clear(ServicePost);
              end;
          end;
        end;
    end;


    procedure SetPrint(Print2: Boolean)
    begin
        Print := Print2;
    end;


    procedure PostUpdateWhseDocuments(var WhseShptHeaderParam: Record "Warehouse Shipment Header")
    var
        WhseShptLine2: Record "Warehouse Shipment Line";
    begin
        with WhseShptLineBuf do
          if Find('-') then begin
            repeat
              WhseShptLine2.Get("No.","Line No.");
              if "Qty. Outstanding" = "Qty. to Ship" then begin
                ItemTrackingMgt.SetDeleteReservationEntries(true);
                ItemTrackingMgt.DeleteWhseItemTrkgLines(
                  Database::"Warehouse Shipment Line",0,"No.",'',0,"Line No.","Location Code",true);
                WhseShptLine2.Delete;
              end else begin
                WhseShptLine2."Qty. Shipped" := "Qty. Shipped" + "Qty. to Ship";
                WhseShptLine2.Validate("Qty. Outstanding","Qty. Outstanding" - "Qty. to Ship");
                WhseShptLine2."Qty. Shipped (Base)" := "Qty. Shipped (Base)" + "Qty. to Ship (Base)";
                WhseShptLine2."Qty. Outstanding (Base)" := "Qty. Outstanding (Base)" - "Qty. to Ship (Base)";
                WhseShptLine2.Status := WhseShptLine2.CalcStatusShptLine;
                WhseShptLine2.Modify;
              end;
            until Next = 0;
            DeleteAll;
          end;

        WhseShptLine2.SetRange("No.",WhseShptHeaderParam."No.");
        if not WhseShptLine2.FindFirst then begin
          WhseShptHeaderParam.DeleteRelatedLines;
          WhseShptHeaderParam.Delete;
        end else begin
          WhseShptHeaderParam."Document Status" := WhseShptHeaderParam.GetDocumentStatus(0);
          if WhseShptHeaderParam."Create Posted Header" then begin
            WhseShptHeaderParam."Last Shipping No." := WhseShptHeaderParam."Shipping No.";
            WhseShptHeaderParam."Shipping No." := '';
            WhseShptHeaderParam."Create Posted Header" := false;
          end;
          WhseShptHeaderParam.Modify;
        end;
    end;


    procedure GetResultMessage()
    var
        MessageText: Text[250];
    begin
        MessageText := Text003;
        if CounterSourceDocOK > 0 then
          MessageText := MessageText + '\\' + Text004;
        if CounterSourceDocOK < CounterSourceDocTotal then
          MessageText := MessageText + '\\' + Text005;
        Message(MessageText,CounterSourceDocOK,CounterSourceDocTotal);
    end;


    procedure SetPostingSettings(PostInvoice: Boolean)
    begin
        Invoice := PostInvoice;
        InvoiceService := PostInvoice;
    end;


    procedure CreatePostedShptHeader(var PostedWhseShptHeader: Record "Posted Whse. Shipment Header";var WhseShptHeader: Record "Warehouse Shipment Header";LastShptNo2: Code[20];PostingDate2: Date)
    var
        WhseComment: Record "Warehouse Comment Line";
        WhseComment2: Record "Warehouse Comment Line";
    begin
        LastShptNo := LastShptNo2;
        PostingDate := PostingDate2;

        if not WhseShptHeader."Create Posted Header" then begin
          PostedWhseShptHeader.Get(WhseShptHeader."Last Shipping No.");
          exit;
        end;

        PostedWhseShptHeader.Init;
        PostedWhseShptHeader."No." := WhseShptHeader."Shipping No.";
        PostedWhseShptHeader."Location Code" := WhseShptHeader."Location Code";
        PostedWhseShptHeader."Assigned User ID" := WhseShptHeader."Assigned User ID";
        PostedWhseShptHeader."Assignment Date" := WhseShptHeader."Assignment Date";
        PostedWhseShptHeader."Assignment Time" := WhseShptHeader."Assignment Time";
        PostedWhseShptHeader."No. Series" := WhseShptHeader."Shipping No. Series";
        PostedWhseShptHeader."Bin Code" := WhseShptHeader."Bin Code";
        PostedWhseShptHeader."Zone Code" := WhseShptHeader."Zone Code";
        PostedWhseShptHeader."Posting Date" := WhseShptHeader."Posting Date";
        PostedWhseShptHeader."Shipment Date" := WhseShptHeader."Shipment Date";
        PostedWhseShptHeader."Shipping Agent Code" := WhseShptHeader."Shipping Agent Code";
        PostedWhseShptHeader."Shipping Agent Service Code" :=
          WhseShptHeader."Shipping Agent Service Code";
        PostedWhseShptHeader."Shipment Method Code" := WhseShptHeader."Shipment Method Code";
        PostedWhseShptHeader.Comment := WhseShptHeader.Comment;
        PostedWhseShptHeader."Whse. Shipment No." := WhseShptHeader."No.";
        PostedWhseShptHeader."External Document No." := WhseShptHeader."External Document No.";
        PostedWhseShptHeader.Insert;

        WhseComment.SetRange("Table Name",WhseComment."table name"::"Whse. Shipment");
        WhseComment.SetRange(Type,WhseComment.Type::" ");
        WhseComment.SetRange("No.",WhseShptHeader."No.");
        if WhseComment.Find('-') then
          repeat
            WhseComment2.Init;
            WhseComment2 := WhseComment;
            WhseComment2."Table Name" := WhseComment2."table name"::"Posted Whse. Shipment";
            WhseComment2."No." := PostedWhseShptHeader."No.";
            WhseComment2.Insert;
          until WhseComment.Next = 0;
    end;


    procedure CreatePostedShptLine(var WhseShptLine: Record "Warehouse Shipment Line";var PostedWhseShptHeader: Record "Posted Whse. Shipment Header";var PostedWhseShptLine: Record "Posted Whse. Shipment Line";var TempHandlingSpecification: Record "Tracking Specification")
    begin
        UpdateWhseShptLineBuf(WhseShptLine);
        with PostedWhseShptLine do begin
          Init;
          TransferFields(WhseShptLine);
          "No." := PostedWhseShptHeader."No.";
          Quantity := WhseShptLine."Qty. to Ship";
          "Qty. (Base)" := WhseShptLine."Qty. to Ship (Base)";
          if WhseShptHeader."Shipment Date" <> 0D then
            "Shipment Date" := PostedWhseShptHeader."Shipment Date";
          "Source Type" := WhseShptLine."Source Type";
          "Source Subtype" := WhseShptLine."Source Subtype";
          "Source No." := WhseShptLine."Source No.";
          "Source Line No." := WhseShptLine."Source Line No.";
          "Source Document" := WhseShptLine."Source Document";
          case "Source Document" of
            "source document"::"Purchase Order":
              "Posted Source Document" := "posted source document"::"Posted Receipt";
            "source document"::"Service Order",
            "source document"::"Sales Order":
              "Posted Source Document" := "posted source document"::"Posted Shipment";
            "source document"::"Purchase Return Order":
              "Posted Source Document" := "posted source document"::"Posted Return Shipment";
            "source document"::"Sales Return Order":
              "Posted Source Document" := "posted source document"::"Posted Return Receipt";
            "source document"::"Outbound Transfer":
              "Posted Source Document" := "posted source document"::"Posted Transfer Shipment";
          end;
          "Posted Source No." := LastShptNo;
          "Posting Date" := PostingDate;
          "Whse. Shipment No." := WhseShptLine."No.";
          "Whse Shipment Line No." := WhseShptLine."Line No.";
          Insert;
        end;

        PostWhseJnlLine(PostedWhseShptLine,TempHandlingSpecification);
    end;

    local procedure UpdateWhseShptLineBuf(WhseShptLine2: Record "Warehouse Shipment Line")
    begin
        with WhseShptLine2 do begin
          WhseShptLineBuf."No." := "No.";
          WhseShptLineBuf."Line No." := "Line No.";
          if not WhseShptLineBuf.Find then begin
            WhseShptLineBuf.Init;
            WhseShptLineBuf := WhseShptLine2;
            WhseShptLineBuf.Insert;
          end;
        end;
    end;

    local procedure PostWhseJnlLine(var PostedWhseShptLine: Record "Posted Whse. Shipment Line";var TempHandlingSpecification: Record "Tracking Specification")
    var
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        TempWhseJnlLine2: Record "Warehouse Journal Line" temporary;
    begin
        GetLocation(PostedWhseShptLine."Location Code");
        if Location."Bin Mandatory" then begin
          CreateWhseJnlLine(TempWhseJnlLine,PostedWhseShptLine);
          WMSMgt.CheckWhseJnlLine(TempWhseJnlLine,0,0,false);

          ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine,TempWhseJnlLine2,TempHandlingSpecification,false);
          if TempWhseJnlLine2.Find('-') then
            repeat
              WhseJnlRegisterLine.Run(TempWhseJnlLine2);
            until TempWhseJnlLine2.Next = 0;
        end;
    end;

    local procedure CreateWhseJnlLine(var WhseJnlLine: Record "Warehouse Journal Line";PostedWhseShptLine: Record "Posted Whse. Shipment Line")
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        with PostedWhseShptLine do begin
          WhseJnlLine.Init;
          WhseJnlLine."Entry Type" := WhseJnlLine."entry type"::"Negative Adjmt.";
          WhseJnlLine."Location Code" := "Location Code";
          WhseJnlLine."From Zone Code" := "Zone Code";
          WhseJnlLine."From Bin Code" := "Bin Code";
          WhseJnlLine."Item No." := "Item No.";
          WhseJnlLine.Description := Description;
          WhseJnlLine."Qty. (Absolute)" := Quantity;
          WhseJnlLine."Qty. (Absolute, Base)" := "Qty. (Base)";
          WhseJnlLine."User ID" := UserId;
          WhseJnlLine."Variant Code" := "Variant Code";
          WhseJnlLine."Unit of Measure Code" := "Unit of Measure Code";
          WhseJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          WhseJnlLine."Source Type" := "Source Type";
          WhseJnlLine."Source Subtype" := "Source Subtype";
          WhseJnlLine."Source No." := "Source No.";
          WhseJnlLine."Source Line No." := "Source Line No.";
          WhseJnlLine."Source Document" := "Source Document";
          WhseJnlLine."Whse. Document Type" := WhseJnlLine."whse. document type"::Shipment;
          WhseJnlLine."Whse. Document No." := "No.";
          WhseJnlLine."Whse. Document Line No." := "Line No.";
          GetItemUnitOfMeasure2("Item No.","Unit of Measure Code");
          WhseJnlLine.Cubage := WhseJnlLine."Qty. (Absolute)" * ItemUnitOfMeasure.Cubage;
          WhseJnlLine.Weight := WhseJnlLine."Qty. (Absolute)" * ItemUnitOfMeasure.Weight;
          WhseJnlLine."Reference No." := LastShptNo;
          WhseJnlLine."Registering Date" := PostingDate;
          WhseJnlLine."Registering No. Series" := WhseShptHeader."Shipping No. Series";
          SourceCodeSetup.Get;
          case "Source Document" of
            "source document"::"Purchase Order":
              begin
                WhseJnlLine."Source Code" := SourceCodeSetup.Purchases;
                WhseJnlLine."Reference Document" :=
                  WhseJnlLine."reference document"::"Posted Rcpt.";
              end;
            "source document"::"Sales Order":
              begin
                WhseJnlLine."Source Code" := SourceCodeSetup.Sales;
                WhseJnlLine."Reference Document" :=
                  WhseJnlLine."reference document"::"Posted Shipment";
              end;
            "source document"::"Service Order":
              begin
                WhseJnlLine."Source Code" := SourceCodeSetup."Service Management";
                WhseJnlLine."Reference Document" := WhseJnlLine."reference document"::"Posted Shipment";
              end;
            "source document"::"Purchase Return Order":
              begin
                WhseJnlLine."Source Code" := SourceCodeSetup.Purchases;
                WhseJnlLine."Reference Document" :=
                  WhseJnlLine."reference document"::"Posted Rtrn. Shipment";
              end;
            "source document"::"Sales Return Order":
              begin
                WhseJnlLine."Source Code" := SourceCodeSetup.Sales;
                WhseJnlLine."Reference Document" :=
                  WhseJnlLine."reference document"::"Posted Rtrn. Rcpt.";
              end;
            "source document"::"Outbound Transfer":
              begin
                WhseJnlLine."Source Code" := SourceCodeSetup.Transfer;
                WhseJnlLine."Reference Document" :=
                  WhseJnlLine."reference document"::"Posted T. Shipment";
              end;
          end;
        end;
    end;

    local procedure GetItemUnitOfMeasure2(ItemNo: Code[20];UOMCode: Code[10])
    begin
        if (ItemUnitOfMeasure."Item No." <> ItemNo) or
           (ItemUnitOfMeasure.Code <> UOMCode)
        then
          if not ItemUnitOfMeasure.Get(ItemNo,UOMCode) then
            ItemUnitOfMeasure.Init;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Location.Init
        else
          if LocationCode <> Location.Code then
            Location.Get(LocationCode);
    end;

    local procedure CheckItemTrkgPicked(WhseShptLine: Record "Warehouse Shipment Line")
    var
        ReservationEntry: Record "Reservation Entry";
        WhseItemTrkgLine: Record "Whse. Item Tracking Line";
        QtyPickedBase: Decimal;
        WhseSNRequired: Boolean;
        WhseLNRequired: Boolean;
    begin
        if WhseShptLine."Assemble to Order" then
          exit;
        ItemTrackingMgt.CheckWhseItemTrkgSetup(WhseShptLine."Item No.",WhseSNRequired,WhseLNRequired,false);
        if not (WhseSNRequired or WhseLNRequired) then
          exit;
        ReservationEntry.SetCurrentkey(
          "Source ID","Source Ref. No.","Source Type","Source Subtype");
        ReservationEntry.SetRange("Source ID",WhseShptLine."Source No.");
        ReservationEntry.SetRange("Source Ref. No.",WhseShptLine."Source Line No.");
        ReservationEntry.SetRange("Source Type",WhseShptLine."Source Type");
        ReservationEntry.SetRange("Source Subtype",WhseShptLine."Source Subtype");
        if ReservationEntry.Find('-') then
          repeat
            if ReservationEntry.TrackingExists then begin
              QtyPickedBase := 0;
              WhseItemTrkgLine.SetCurrentkey("Serial No.","Lot No.");
              WhseItemTrkgLine.SetRange("Serial No.",ReservationEntry."Serial No.");
              WhseItemTrkgLine.SetRange("Lot No.",ReservationEntry."Lot No.");
              WhseItemTrkgLine.SetRange("Source Type",Database::"Warehouse Shipment Line");
              WhseItemTrkgLine.SetRange("Source ID",WhseShptLine."No.");
              WhseItemTrkgLine.SetRange("Source Ref. No.",WhseShptLine."Line No.");
              if WhseItemTrkgLine.Find('-') then
                repeat
                  QtyPickedBase := QtyPickedBase + WhseItemTrkgLine."Qty. Registered (Base)";
                until WhseItemTrkgLine.Next = 0;
              if QtyPickedBase < Abs(ReservationEntry."Qty. to Handle (Base)") then
                Error(Text006,
                  WhseShptLine."No.",WhseShptLine.FieldCaption("Line No."),WhseShptLine."Line No.");
            end;
          until ReservationEntry.Next = 0;
    end;

    local procedure HandleSalesLine(var WhseShptLine: Record "Warehouse Shipment Line")
    var
        SalesLine: Record "Sales Line";
        ATOWhseShptLine: Record "Warehouse Shipment Line";
        NonATOWhseShptLine: Record "Warehouse Shipment Line";
        ATOLink: Record "Assemble-to-Order Link";
        AsmHeader: Record "Assembly Header";
        ModifyLine: Boolean;
        ATOLineFound: Boolean;
        NonATOLineFound: Boolean;
        SumOfQtyToShip: Decimal;
        SumOfQtyToShipBase: Decimal;
    begin
        with WhseShptLine do begin
          SalesLine.SetRange("Document Type","Source Subtype");
          SalesLine.SetRange("Document No.","Source No.");
          if SalesLine.Find('-') then
            repeat
              SetRange("Source Line No.",SalesLine."Line No.");
              if Find('-') then begin
                if "Source Document" = "source document"::"Sales Order" then begin
                  SumOfQtyToShip := 0;
                  SumOfQtyToShipBase := 0;
                  GetATOAndNonATOLines(ATOWhseShptLine,NonATOWhseShptLine,ATOLineFound,NonATOLineFound);
                  if ATOLineFound then begin
                    SumOfQtyToShip += ATOWhseShptLine."Qty. to Ship";
                    SumOfQtyToShipBase += ATOWhseShptLine."Qty. to Ship (Base)";
                  end;
                  if NonATOLineFound then begin
                    SumOfQtyToShip += NonATOWhseShptLine."Qty. to Ship";
                    SumOfQtyToShipBase += NonATOWhseShptLine."Qty. to Ship (Base)";
                  end;

                  ModifyLine := SalesLine."Qty. to Ship" <> SumOfQtyToShip;
                  if ModifyLine then begin
                    SalesLine.Validate("Qty. to Ship",SumOfQtyToShip);
                    SalesLine."Qty. to Ship (Base)" := SumOfQtyToShipBase;
                    if ATOLineFound then
                      ATOLink.UpdateQtyToAsmFromWhseShptLine(ATOWhseShptLine);
                    if Invoice then
                      SalesLine.Validate(
                        "Qty. to Invoice",
                        SalesLine."Qty. to Ship" + SalesLine."Quantity Shipped" - SalesLine."Quantity Invoiced");
                  end;
                end else begin
                  ModifyLine := SalesLine."Return Qty. to Receive" <> -"Qty. to Ship";
                  if ModifyLine then begin
                    SalesLine.Validate("Return Qty. to Receive",-"Qty. to Ship");
                    if Invoice then
                      SalesLine.Validate(
                        "Qty. to Invoice",
                        -"Qty. to Ship" + SalesLine."Return Qty. Received" - SalesLine."Quantity Invoiced");
                  end;
                end;
                if (WhseShptHeader."Shipment Date" <> 0D) and
                   (SalesLine."Shipment Date" <> WhseShptHeader."Shipment Date") and
                   ("Qty. to Ship" = "Qty. Outstanding")
                then begin
                  SalesLine."Shipment Date" := WhseShptHeader."Shipment Date";
                  ModifyLine := true;
                  if ATOLineFound then
                    if AsmHeader.Get(ATOLink."Assembly Document Type",ATOLink."Assembly Document No.") then begin
                      AsmHeader."Due Date" := WhseShptHeader."Shipment Date";
                      AsmHeader.Modify(true);
                    end;
                end;
                if SalesLine."Bin Code" <> "Bin Code" then begin
                  SalesLine."Bin Code" := "Bin Code";
                  ModifyLine := true;
                  if ATOLineFound then
                    ATOLink.UpdateAsmBinCodeFromWhseShptLine(ATOWhseShptLine);
                end;
              end else begin
                ModifyLine :=
                  ((SalesHeader."Shipping Advice" <> SalesHeader."shipping advice"::Complete) or
                   (SalesLine.Type = SalesLine.Type::Item)) and
                  ((SalesLine."Qty. to Ship" <> 0) or
                   (SalesLine."Return Qty. to Receive" <> 0) or
                   (SalesLine."Qty. to Invoice" <> 0));

                if ModifyLine then begin
                  if "Source Document" = "source document"::"Sales Order" then
                    SalesLine.Validate("Qty. to Ship",0)
                  else
                    SalesLine.Validate("Return Qty. to Receive",0);
                  SalesLine.Validate("Qty. to Invoice",0);
                end;
              end;
              if ModifyLine then
                SalesLine.Modify;
            until SalesLine.Next = 0;
        end;
    end;

    local procedure HandlePurchaseLine(var WhseShptLine: Record "Warehouse Shipment Line")
    var
        PurchLine: Record "Purchase Line";
        ModifyLine: Boolean;
    begin
        with WhseShptLine do begin
          PurchLine.SetRange("Document Type","Source Subtype");
          PurchLine.SetRange("Document No.","Source No.");
          if PurchLine.Find('-') then
            repeat
              SetRange("Source Line No.",PurchLine."Line No.");
              if Find('-') then begin
                if "Source Document" = "source document"::"Purchase Order" then begin
                  ModifyLine := PurchLine."Qty. to Receive" <> -"Qty. to Ship";
                  if ModifyLine then begin
                    PurchLine.Validate("Qty. to Receive",-"Qty. to Ship");
                    if Invoice then
                      PurchLine.Validate(
                        "Qty. to Invoice",
                        -"Qty. to Ship" + PurchLine."Quantity Received" - PurchLine."Quantity Invoiced");
                  end;
                end else begin
                  ModifyLine := PurchLine."Return Qty. to Ship" <> "Qty. to Ship";
                  if ModifyLine then begin
                    PurchLine.Validate("Return Qty. to Ship","Qty. to Ship");
                    if Invoice then
                      PurchLine.Validate(
                        "Qty. to Invoice",
                        "Qty. to Ship" + PurchLine."Return Qty. Shipped" - PurchLine."Quantity Invoiced");
                  end;
                end;
                if (WhseShptHeader."Shipment Date" <> 0D) and
                   (PurchLine."Expected Receipt Date" <> WhseShptHeader."Shipment Date") and
                   ("Qty. to Ship" = "Qty. Outstanding")
                then begin
                  PurchLine."Expected Receipt Date" := WhseShptHeader."Shipment Date";
                  ModifyLine := true;
                end;
                if PurchLine."Bin Code" <> "Bin Code" then begin
                  PurchLine."Bin Code" := "Bin Code";
                  ModifyLine := true;
                end;
              end else begin
                ModifyLine :=
                  (PurchLine."Qty. to Receive" <> 0) or
                  (PurchLine."Return Qty. to Ship" <> 0) or
                  (PurchLine."Qty. to Invoice" <> 0);
                if ModifyLine then begin
                  if "Source Document" = "source document"::"Purchase Order" then
                    PurchLine.Validate("Qty. to Receive",0)
                  else
                    PurchLine.Validate("Return Qty. to Ship",0);
                  PurchLine.Validate("Qty. to Invoice",0);
                end;
              end;
              if ModifyLine then
                PurchLine.Modify;
            until PurchLine.Next = 0;
        end;
    end;

    local procedure HandleTransferLine(var WhseShptLine: Record "Warehouse Shipment Line")
    var
        TransLine: Record "Transfer Line";
        ModifyLine: Boolean;
    begin
        with WhseShptLine do begin
          TransLine.SetRange("Document No.","Source No.");
          TransLine.SetRange("Derived From Line No.",0);
          if TransLine.Find('-') then
            repeat
              SetRange("Source Line No.",TransLine."Line No.");
              if Find('-') then begin
                ModifyLine := TransLine."Qty. to Ship" <> "Qty. to Ship";
                if ModifyLine then
                  TransLine.Validate("Qty. to Ship","Qty. to Ship");
                if (WhseShptHeader."Shipment Date" <> 0D) and
                   (TransLine."Shipment Date" <> WhseShptHeader."Shipment Date") and
                   ("Qty. to Ship" = "Qty. Outstanding")
                then begin
                  TransLine."Shipment Date" := WhseShptHeader."Shipment Date";
                  ModifyLine := true;
                end;
                if TransLine."Transfer-from Bin Code" <> "Bin Code" then begin
                  TransLine."Transfer-from Bin Code" := "Bin Code";
                  ModifyLine := true;
                end;
              end else begin
                ModifyLine := TransLine."Qty. to Ship" <> 0;
                if ModifyLine then begin
                  TransLine.Validate("Qty. to Ship",0);
                  TransLine.Validate("Qty. to Receive",0);
                end;
              end;
              if ModifyLine then
                TransLine.Modify;
            until TransLine.Next = 0;
        end;
    end;

    local procedure HandleServiceLine(var WhseShptLine: Record "Warehouse Shipment Line")
    var
        ServLine: Record "Service Line";
        ModifyLine: Boolean;
    begin
        with WhseShptLine do begin
          ServLine.SetRange("Document Type","Source Subtype");
          ServLine.SetRange("Document No.","Source No.");
          if ServLine.Find('-') then
            repeat
              SetRange("Source Line No.",ServLine."Line No.");  // Whse Shipment Line
              if Find('-') then begin   // Whse Shipment Line
                if "Source Document" = "source document"::"Service Order" then begin
                  ModifyLine := ServLine."Qty. to Ship" <> "Qty. to Ship";
                  if ModifyLine then begin
                    ServLine.Validate("Qty. to Ship","Qty. to Ship");
                    ServLine."Qty. to Ship (Base)" := "Qty. to Ship (Base)";
                    if InvoiceService then begin
                      ServLine.Validate("Qty. to Consume",0);
                      ServLine.Validate(
                        "Qty. to Invoice",
                        "Qty. to Ship" + ServLine."Quantity Shipped" - ServLine."Quantity Invoiced" -
                        ServLine."Quantity Consumed");
                    end;
                  end;
                end;
                if ServLine."Bin Code" <> "Bin Code" then begin
                  ServLine."Bin Code" := "Bin Code";
                  ModifyLine := true;
                end;
              end else begin
                ModifyLine :=
                  ((ServiceHeader."Shipping Advice" <> ServiceHeader."shipping advice"::Complete) or
                   (ServLine.Type = ServLine.Type::Item)) and
                  ((ServLine."Qty. to Ship" <> 0) or
                   (ServLine."Qty. to Consume" <> 0) or
                   (ServLine."Qty. to Invoice" <> 0));

                if ModifyLine then begin
                  if "Source Document" = "source document"::"Service Order" then
                    ServLine.Validate("Qty. to Ship",0);
                  ServLine.Validate("Qty. to Invoice",0);
                  ServLine.Validate("Qty. to Consume",0);
                end;
              end;
              if ModifyLine then
                ServLine.Modify;
            until ServLine.Next = 0;
        end;
    end;

    local procedure ModifyIfDifferent(var Target: Code[10];Source: Code[10]): Boolean
    begin
        if (Source = '') or (Target = Source) then
          exit(false);
        Target := Source;
        exit(true);
    end;


    procedure SetWhseJnlRegisterCU(var NewWhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line")
    begin
        WhseJnlRegisterLine := NewWhseJnlRegisterLine;
    end;
}

