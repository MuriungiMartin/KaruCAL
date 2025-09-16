#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 364 "PostPurch-Delete"
{
    Permissions = TableData "Purch. Rcpt. Line"=rd,
                  TableData "Purch. Inv. Line"=d,
                  TableData "Purch. Cr. Memo Line"=d,
                  TableData "Return Shipment Line"=rd;

    trigger OnRun()
    begin
    end;

    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchShptLine: Record "Return Shipment Line";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        MoveEntries: Codeunit MoveEntries;
        DocumentDeletionErr: label 'You cannot delete posted purchase documents that are posted after %1. \\The date is defined by the Allow Document Deletion Before field in the Purchases & Payables Setup window.', Comment='%1 - Posting Date';


    procedure DeleteHeader(PurchHeader: Record "Purchase Header";var PurchRcptHeader: Record "Purch. Rcpt. Header";var PurchInvHeader: Record "Purch. Inv. Header";var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";var ReturnShptHeader: Record "Return Shipment Header";var PurchInvHeaderPrepmt: Record "Purch. Inv. Header";var PurchCrMemoHdrPrepmt: Record "Purch. Cr. Memo Hdr.")
    var
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ReturnShptLine: Record "Return Shipment Line";
        SourceCode: Record "Source Code";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        with PurchHeader do begin
          SourceCodeSetup.Get;
          SourceCodeSetup.TestField("Deleted Document");
          SourceCode.Get(SourceCodeSetup."Deleted Document");

          InitDeleteHeader(
            PurchHeader,PurchRcptHeader,PurchInvHeader,PurchCrMemoHdr,
            ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHdrPrepmt,SourceCode.Code);
          if PurchRcptHeader."No." <> '' then begin
            PurchRcptHeader.Insert;
            PurchRcptLine.Init;
            PurchRcptLine."Document No." := PurchRcptHeader."No.";
            PurchRcptLine."Line No." := 10000;
            PurchRcptLine.Description := SourceCode.Description;
            PurchRcptLine.Insert;
          end;

          if ReturnShptHeader."No." <> '' then begin
            ReturnShptHeader.Insert;
            ReturnShptLine.Init;
            ReturnShptLine."Document No." := ReturnShptHeader."No.";
            ReturnShptLine."Line No." := 10000;
            ReturnShptLine.Description := SourceCode.Description;
            ReturnShptLine.Insert;
          end;

          if PurchInvHeader."No." <> '' then begin
            PurchInvHeader.Insert;
            PurchInvLine.Init;
            PurchInvLine."Document No." := PurchInvHeader."No.";
            PurchInvLine."Line No." := 10000;
            PurchInvLine.Description := SourceCode.Description;
            PurchInvLine.Insert;
          end;

          if PurchCrMemoHdr."No." <> '' then begin
            PurchCrMemoHdr.Insert(true);
            PurchCrMemoLine.Init;
            PurchCrMemoLine."Document No." := PurchCrMemoHdr."No.";
            PurchCrMemoLine."Line No." := 10000;
            PurchCrMemoLine.Description := SourceCode.Description;
            PurchCrMemoLine.Insert;
          end;

          if PurchInvHeaderPrepmt."No." <> '' then begin
            PurchInvHeaderPrepmt.Insert;
            PurchInvLine."Document No." := PurchInvHeaderPrepmt."No.";
            PurchInvLine."Line No." := 10000;
            PurchInvLine.Description := SourceCode.Description;
            PurchInvLine.Insert;
          end;

          if PurchCrMemoHdrPrepmt."No." <> '' then begin
            PurchCrMemoHdrPrepmt.Insert;
            PurchCrMemoLine.Init;
            PurchCrMemoLine."Document No." := PurchCrMemoHdrPrepmt."No.";
            PurchCrMemoLine."Line No." := 10000;
            PurchCrMemoLine.Description := SourceCode.Description;
            PurchCrMemoLine.Insert;
          end;
        end;
    end;


    procedure DeletePurchRcptLines(PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        PurchRcptLine.SetRange("Document No.",PurchRcptHeader."No.");
        if PurchRcptLine.Find('-') then
          repeat
            PurchRcptLine.TestField("Quantity Invoiced",PurchRcptLine.Quantity);
            PurchRcptLine.Delete;
          until PurchRcptLine.Next = 0;
        ItemTrackingMgt.DeleteItemEntryRelation(
          Database::"Purch. Rcpt. Line",0,PurchRcptHeader."No.",'',0,0,true);

        MoveEntries.MoveDocRelatedEntries(Database::"Purch. Rcpt. Header",PurchRcptHeader."No.");
    end;


    procedure DeletePurchInvLines(PurchInvHeader: Record "Purch. Inv. Header")
    begin
        PurchInvLine.SetRange("Document No.",PurchInvHeader."No.");
        if PurchInvLine.Find('-') then
          repeat
            PurchInvLine.Delete;
            ItemTrackingMgt.DeleteValueEntryRelation(PurchInvLine.RowID1);
          until PurchInvLine.Next = 0;

        MoveEntries.MoveDocRelatedEntries(Database::"Purch. Inv. Header",PurchInvHeader."No.");
    end;


    procedure DeletePurchCrMemoLines(PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.")
    begin
        PurchCrMemoLine.SetRange("Document No.",PurchCrMemoHeader."No.");
        if PurchCrMemoLine.Find('-') then
          repeat
            PurchCrMemoLine.Delete;
          until PurchCrMemoLine.Next = 0;
        ItemTrackingMgt.DeleteItemEntryRelation(
          Database::"Purch. Cr. Memo Line",0,PurchCrMemoHeader."No.",'',0,0,true);

        MoveEntries.MoveDocRelatedEntries(Database::"Purch. Cr. Memo Hdr.",PurchCrMemoHeader."No.");
    end;


    procedure DeletePurchShptLines(ReturnShptHeader: Record "Return Shipment Header")
    begin
        PurchShptLine.SetRange("Document No.",ReturnShptHeader."No.");
        if PurchShptLine.Find('-') then
          repeat
            PurchShptLine.TestField("Quantity Invoiced",PurchShptLine.Quantity);
            PurchShptLine.Delete;
          until PurchShptLine.Next = 0;
        ItemTrackingMgt.DeleteItemEntryRelation(
          Database::"Return Shipment Line",0,ReturnShptHeader."No.",'',0,0,true);

        MoveEntries.MoveDocRelatedEntries(Database::"Return Shipment Header",ReturnShptHeader."No.");
    end;


    procedure InitDeleteHeader(PurchHeader: Record "Purchase Header";var PurchRcptHeader: Record "Purch. Rcpt. Header";var PurchInvHeader: Record "Purch. Inv. Header";var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";var ReturnShptHeader: Record "Return Shipment Header";var PurchInvHeaderPrepmt: Record "Purch. Inv. Header";var PurchCrMemoHdrPrepmt: Record "Purch. Cr. Memo Hdr.";SourceCode: Code[10])
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        with PurchHeader do begin
          Clear(PurchRcptHeader);
          Clear(PurchInvHeader);
          Clear(PurchCrMemoHdr);
          Clear(ReturnShptHeader);
          PurchSetup.Get;

          if ("Receiving No. Series" <> '') and ("Receiving No." <> '') then begin
            PurchRcptHeader.TransferFields(PurchHeader);
            PurchRcptHeader."No." := "Receiving No.";
            PurchRcptHeader."Posting Date" := Today;
            PurchRcptHeader."User ID" := UserId;
            PurchRcptHeader."Source Code" := SourceCode;
          end;

          if ("Return Shipment No. Series" <> '') and ("Return Shipment No." <> '') then begin
            ReturnShptHeader.TransferFields(PurchHeader);
            ReturnShptHeader."No." := "Return Shipment No.";
            ReturnShptHeader."Posting Date" := Today;
            ReturnShptHeader."User ID" := UserId;
            ReturnShptHeader."Source Code" := SourceCode;
          end;

          if ("Posting No. Series" <> '') and
             (("Document Type" in ["document type"::Order,"document type"::Invoice]) and
              ("Posting No." <> '') or
              ("Document Type" = "document type"::Invoice) and
              ("No. Series" = "Posting No. Series"))
          then begin
            PurchInvHeader.TransferFields(PurchHeader);
            if "Posting No." <> '' then
              PurchInvHeader."No." := "Posting No.";
            if "Document Type" = "document type"::Invoice then begin
              PurchInvHeader."Pre-Assigned No. Series" := "No. Series";
              PurchInvHeader."Pre-Assigned No." := "No.";
            end else begin
              PurchInvHeader."Pre-Assigned No. Series" := '';
              PurchInvHeader."Pre-Assigned No." := '';
              PurchInvHeader."Order No. Series" := "No. Series";
              PurchInvHeader."Order No." := "No.";
            end;
            PurchInvHeader."Posting Date" := Today;
            PurchInvHeader."User ID" := UserId;
            PurchInvHeader."Source Code" := SourceCode;
          end;

          if ("Posting No. Series" <> '') and
             (("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]) and
              ("Posting No." <> '') or
              ("Document Type" = "document type"::"Credit Memo") and
              ("No. Series" = "Posting No. Series"))
          then begin
            PurchCrMemoHdr.TransferFields(PurchHeader);
            if "Posting No." <> '' then
              PurchCrMemoHdr."No." := "Posting No.";
            PurchCrMemoHdr."Pre-Assigned No. Series" := "No. Series";
            PurchCrMemoHdr."Pre-Assigned No." := "No.";
            PurchCrMemoHdr."Posting Date" := Today;
            PurchCrMemoHdr."User ID" := UserId;
            PurchCrMemoHdr."Source Code" := SourceCode;
          end;

          if ("Prepayment No. Series" <> '') and ("Prepayment No." <> '') then begin
            TestField("Document Type","document type"::Order);
            PurchInvHeaderPrepmt.TransferFields(PurchHeader);
            PurchInvHeaderPrepmt."No." := "Prepayment No.";
            PurchInvHeaderPrepmt."Order No. Series" := "No. Series";
            PurchInvHeaderPrepmt."Prepayment Order No." := "No.";
            PurchInvHeaderPrepmt."Posting Date" := Today;
            PurchInvHeaderPrepmt."Pre-Assigned No. Series" := '';
            PurchInvHeaderPrepmt."Pre-Assigned No." := '';
            PurchInvHeaderPrepmt."User ID" := UserId;
            PurchInvHeaderPrepmt."Source Code" := SourceCode;
            PurchInvHeaderPrepmt."Prepayment Invoice" := true;
          end;

          if ("Prepmt. Cr. Memo No. Series" <> '') and ("Prepmt. Cr. Memo No." <> '') then begin
            TestField("Document Type","document type"::Order);
            PurchCrMemoHdrPrepmt.TransferFields(PurchHeader);
            PurchCrMemoHdrPrepmt."No." := "Prepmt. Cr. Memo No.";
            PurchCrMemoHdrPrepmt."Prepayment Order No." := "No.";
            PurchCrMemoHdrPrepmt."Posting Date" := Today;
            PurchCrMemoHdrPrepmt."Pre-Assigned No. Series" := '';
            PurchCrMemoHdrPrepmt."Pre-Assigned No." := '';
            PurchCrMemoHdrPrepmt."User ID" := UserId;
            PurchCrMemoHdrPrepmt."Source Code" := SourceCode;
            PurchCrMemoHdrPrepmt."Prepayment Credit Memo" := true;
          end;
        end;
    end;


    procedure IsDocumentDeletionAllowed(PostingDate: Date)
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        PurchSetup.Get;
        if PurchSetup."Allow Document Deletion Before" <> 0D then
          if PostingDate >= PurchSetup."Allow Document Deletion Before" then
            Error(StrSubstNo(DocumentDeletionErr,PurchSetup."Allow Document Deletion Before"));
    end;
}

