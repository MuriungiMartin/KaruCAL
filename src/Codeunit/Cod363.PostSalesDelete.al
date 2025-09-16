#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 363 "PostSales-Delete"
{
    Permissions = TableData "Sales Shipment Header"=i,
                  TableData "Sales Shipment Line"=rid,
                  TableData "Sales Invoice Header"=i,
                  TableData "Sales Invoice Line"=rid,
                  TableData "Sales Cr.Memo Header"=i,
                  TableData "Sales Cr.Memo Line"=rid,
                  TableData "Return Receipt Header"=i,
                  TableData "Return Receipt Line"=rid;

    trigger OnRun()
    begin
    end;

    var
        SalesShptLine: Record "Sales Shipment Line";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesRcptLine: Record "Return Receipt Line";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        MoveEntries: Codeunit MoveEntries;
        DocumentDeletionErr: label 'You cannot delete posted sales documents that are posted after %1. \\The date is defined by the Allow Document Deletion Before field in the Sales & Receivables Setup window.', Comment='%1 - Posting Date';


    procedure DeleteHeader(SalesHeader: Record "Sales Header";var SalesShptHeader: Record "Sales Shipment Header";var SalesInvHeader: Record "Sales Invoice Header";var SalesCrMemoHeader: Record "Sales Cr.Memo Header";var ReturnRcptHeader: Record "Return Receipt Header";var SalesInvHeaderPrePmt: Record "Sales Invoice Header";var SalesCrMemoHeaderPrePmt: Record "Sales Cr.Memo Header")
    var
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
        SourceCode: Record "Source Code";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        with SalesHeader do begin
          SourceCodeSetup.Get;
          SourceCodeSetup.TestField("Deleted Document");
          SourceCode.Get(SourceCodeSetup."Deleted Document");

          InitDeleteHeader(
            SalesHeader,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,
            ReturnRcptHeader,SalesInvHeaderPrePmt,SalesCrMemoHeaderPrePmt,SourceCode.Code);

          if SalesShptHeader."No." <> '' then begin
            SalesShptHeader.Insert;
            SalesShptLine.Init;
            SalesShptLine."Document No." := SalesShptHeader."No.";
            SalesShptLine."Line No." := 10000;
            SalesShptLine.Description := SourceCode.Description;
            SalesShptLine.Insert;
          end;

          if ReturnRcptHeader."No." <> '' then begin
            ReturnRcptHeader.Insert;
            ReturnRcptLine.Init;
            ReturnRcptLine."Document No." := ReturnRcptHeader."No.";
            ReturnRcptLine."Line No." := 10000;
            ReturnRcptLine.Description := SourceCode.Description;
            ReturnRcptLine.Insert;
          end;

          if SalesInvHeader."No." <> '' then begin
            SalesInvHeader.Insert;
            SalesInvLine.Init;
            SalesInvLine."Document No." := SalesInvHeader."No.";
            SalesInvLine."Line No." := 10000;
            SalesInvLine.Description := SourceCode.Description;
            SalesInvLine.Insert;
          end;

          if SalesCrMemoHeader."No." <> '' then begin
            SalesCrMemoHeader.Insert;
            SalesCrMemoLine.Init;
            SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
            SalesCrMemoLine."Line No." := 10000;
            SalesCrMemoLine.Description := SourceCode.Description;
            SalesCrMemoLine.Insert;
          end;

          if SalesInvHeaderPrePmt."No." <> '' then begin
            SalesInvHeaderPrePmt.Insert;
            SalesInvLine."Document No." := SalesInvHeaderPrePmt."No.";
            SalesInvLine."Line No." := 10000;
            SalesInvLine.Description := SourceCode.Description;
            SalesInvLine.Insert;
          end;

          if SalesCrMemoHeaderPrePmt."No." <> '' then begin
            SalesCrMemoHeaderPrePmt.Insert;
            SalesCrMemoLine.Init;
            SalesCrMemoLine."Document No." := SalesCrMemoHeaderPrePmt."No.";
            SalesCrMemoLine."Line No." := 10000;
            SalesCrMemoLine.Description := SourceCode.Description;
            SalesCrMemoLine.Insert;
          end;
        end;
    end;


    procedure DeleteSalesShptLines(SalesShptHeader: Record "Sales Shipment Header")
    begin
        SalesShptLine.SetRange("Document No.",SalesShptHeader."No.");
        if SalesShptLine.Find('-') then
          repeat
            SalesShptLine.TestField("Quantity Invoiced",SalesShptLine.Quantity);
            SalesShptLine.Delete(true);
          until SalesShptLine.Next = 0;
        ItemTrackingMgt.DeleteItemEntryRelation(
          Database::"Sales Shipment Line",0,SalesShptHeader."No.",'',0,0,true);

        MoveEntries.MoveDocRelatedEntries(Database::"Sales Shipment Header",SalesShptHeader."No.");
    end;


    procedure DeleteSalesInvLines(SalesInvHeader: Record "Sales Invoice Header")
    begin
        SalesInvLine.SetRange("Document No.",SalesInvHeader."No.");
        if SalesInvLine.Find('-') then
          repeat
            SalesInvLine.Delete;
            ItemTrackingMgt.DeleteValueEntryRelation(SalesInvLine.RowID1);
          until SalesInvLine.Next = 0;

        MoveEntries.MoveDocRelatedEntries(Database::"Sales Invoice Header",SalesInvHeader."No.");
    end;


    procedure DeleteSalesCrMemoLines(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        SalesCrMemoLine.SetRange("Document No.",SalesCrMemoHeader."No.");
        if SalesCrMemoLine.Find('-') then
          repeat
            SalesCrMemoLine.Delete;
          until SalesCrMemoLine.Next = 0;
        ItemTrackingMgt.DeleteItemEntryRelation(
          Database::"Sales Cr.Memo Line",0,SalesCrMemoHeader."No.",'',0,0,true);

        MoveEntries.MoveDocRelatedEntries(Database::"Sales Cr.Memo Header",SalesCrMemoHeader."No.");
    end;


    procedure DeleteSalesRcptLines(ReturnRcptHeader: Record "Return Receipt Header")
    begin
        SalesRcptLine.SetRange("Document No.",ReturnRcptHeader."No.");
        if SalesRcptLine.Find('-') then
          repeat
            SalesRcptLine.TestField("Quantity Invoiced",SalesRcptLine.Quantity);
            SalesRcptLine.Delete;
          until SalesRcptLine.Next = 0;
        ItemTrackingMgt.DeleteItemEntryRelation(
          Database::"Return Receipt Line",0,ReturnRcptHeader."No.",'',0,0,true);

        MoveEntries.MoveDocRelatedEntries(Database::"Return Receipt Header",ReturnRcptHeader."No.");
    end;


    procedure InitDeleteHeader(SalesHeader: Record "Sales Header";var SalesShptHeader: Record "Sales Shipment Header";var SalesInvHeader: Record "Sales Invoice Header";var SalesCrMemoHeader: Record "Sales Cr.Memo Header";var ReturnRcptHeader: Record "Return Receipt Header";var SalesInvHeaderPrePmt: Record "Sales Invoice Header";var SalesCrMemoHeaderPrePmt: Record "Sales Cr.Memo Header";SourceCode: Code[10])
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        with SalesHeader do begin
          Clear(SalesShptHeader);
          Clear(SalesInvHeader);
          Clear(SalesCrMemoHeader);
          Clear(ReturnRcptHeader);
          SalesSetup.Get;

          if ("Shipping No. Series" <> '') and ("Shipping No." <> '') then begin
            SalesShptHeader.TransferFields(SalesHeader);
            SalesShptHeader."No." := "Shipping No.";
            SalesShptHeader."Posting Date" := Today;
            SalesShptHeader."User ID" := UserId;
            SalesShptHeader."Source Code" := SourceCode;
          end;

          if ("Return Receipt No. Series" <> '') and ("Return Receipt No." <> '') then begin
            ReturnRcptHeader.TransferFields(SalesHeader);
            ReturnRcptHeader."No." := "Return Receipt No.";
            ReturnRcptHeader."Posting Date" := Today;
            ReturnRcptHeader."User ID" := UserId;
            ReturnRcptHeader."Source Code" := SourceCode;
          end;

          if ("Posting No. Series" <> '') and
             (("Document Type" in ["document type"::Order,"document type"::Invoice]) and
              ("Posting No." <> '') or
              ("Document Type" = "document type"::Invoice) and
              ("No. Series" = "Posting No. Series"))
          then begin
            SalesInvHeader.TransferFields(SalesHeader);
            if "Posting No." <> '' then
              SalesInvHeader."No." := "Posting No.";
            if "Document Type" = "document type"::Invoice then begin
              SalesInvHeader."Pre-Assigned No. Series" := "No. Series";
              SalesInvHeader."Pre-Assigned No." := "No.";
            end else begin
              SalesInvHeader."Pre-Assigned No. Series" := '';
              SalesInvHeader."Pre-Assigned No." := '';
              SalesInvHeader."Order No. Series" := "No. Series";
              SalesInvHeader."Order No." := "No.";
            end;
            SalesInvHeader."Posting Date" := Today;
            SalesInvHeader."User ID" := UserId;
            SalesInvHeader."Source Code" := SourceCode;
          end;

          if ("Posting No. Series" <> '') and
             (("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]) and
              ("Posting No." <> '') or
              ("Document Type" = "document type"::"Credit Memo") and
              ("No. Series" = "Posting No. Series"))
          then begin
            SalesCrMemoHeader.TransferFields(SalesHeader);
            if "Posting No." <> '' then
              SalesCrMemoHeader."No." := "Posting No.";
            SalesCrMemoHeader."Pre-Assigned No. Series" := "No. Series";
            SalesCrMemoHeader."Pre-Assigned No." := "No.";
            SalesCrMemoHeader."Posting Date" := Today;
            SalesCrMemoHeader."User ID" := UserId;
            SalesCrMemoHeader."Source Code" := SourceCode;
          end;
          if ("Prepayment No. Series" <> '') and ("Prepayment No." <> '') then begin
            TestField("Document Type","document type"::Order);
            SalesInvHeaderPrePmt.TransferFields(SalesHeader);
            SalesInvHeaderPrePmt."No." := "Prepayment No.";
            SalesInvHeaderPrePmt."Order No. Series" := "No. Series";
            SalesInvHeaderPrePmt."Prepayment Order No." := "No.";
            SalesInvHeaderPrePmt."Posting Date" := Today;
            SalesInvHeaderPrePmt."Pre-Assigned No. Series" := '';
            SalesInvHeaderPrePmt."Pre-Assigned No." := '';
            SalesInvHeaderPrePmt."User ID" := UserId;
            SalesInvHeaderPrePmt."Source Code" := SourceCode;
            SalesInvHeaderPrePmt."Prepayment Invoice" := true;
          end;

          if ("Prepmt. Cr. Memo No. Series" <> '') and ("Prepmt. Cr. Memo No." <> '') then begin
            TestField("Document Type","document type"::Order);
            SalesCrMemoHeaderPrePmt.TransferFields(SalesHeader);
            SalesCrMemoHeaderPrePmt."No." := "Prepmt. Cr. Memo No.";
            SalesCrMemoHeaderPrePmt."Prepayment Order No." := "No.";
            SalesCrMemoHeaderPrePmt."Posting Date" := Today;
            SalesCrMemoHeaderPrePmt."Pre-Assigned No. Series" := '';
            SalesCrMemoHeaderPrePmt."Pre-Assigned No." := '';
            SalesCrMemoHeaderPrePmt."User ID" := UserId;
            SalesCrMemoHeaderPrePmt."Source Code" := SourceCode;
            SalesCrMemoHeaderPrePmt."Prepayment Credit Memo" := true;
          end;
        end;
    end;


    procedure IsDocumentDeletionAllowed(PostingDate: Date)
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        if SalesSetup."Allow Document Deletion Before" <> 0D then
          if PostingDate >= SalesSetup."Allow Document Deletion Before" then
            Error(StrSubstNo(DocumentDeletionErr,SalesSetup."Allow Document Deletion Before"));
    end;
}

