#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 96 "Purch.-Quote to Order"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    var
        OldPurchCommentLine: Record "Purch. Comment Line";
        Vend: Record Vendor;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecordLinkManagement: Codeunit "Record Link Management";
        ShouldRedistributeInvoiceAmount: Boolean;
    begin
        TestField("Document Type","document type"::Quote);
        ShouldRedistributeInvoiceAmount := PurchCalcDiscByType.ShouldRedistributeInvoiceDiscountAmount(Rec);

        OnCheckPurchasePostRestrictions;

        Vend.Get("Buy-from Vendor No.");
        Vend.CheckBlockedVendOnDocs(Vend,false);

        PurchOrderHeader := Rec;
        PurchOrderHeader."Document Type" := PurchOrderHeader."document type"::Order;
        PurchOrderHeader."No. Printed" := 0;
        PurchOrderHeader.Status := PurchOrderHeader.Status::Open;
        PurchOrderHeader."No." := '';
        PurchOrderHeader."Quote No." := "No.";

        PurchOrderLine.LockTable;
        PurchOrderHeader.Insert(true);

        PurchOrderHeader."Order Date" := "Order Date";
        if "Posting Date" <> 0D then
          PurchOrderHeader."Posting Date" := "Posting Date";
        PurchOrderHeader."Document Date" := "Document Date";
        PurchOrderHeader."Expected Receipt Date" := "Expected Receipt Date";
        PurchOrderHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        PurchOrderHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        PurchOrderHeader."Dimension Set ID" := "Dimension Set ID";

        PurchOrderHeader."Location Code" := "Location Code";
        PurchOrderHeader."Inbound Whse. Handling Time" := "Inbound Whse. Handling Time";
        PurchOrderHeader."Ship-to Name" := "Ship-to Name";
        PurchOrderHeader."Ship-to Name 2" := "Ship-to Name 2";
        PurchOrderHeader."Ship-to Address" := "Ship-to Address";
        PurchOrderHeader."Ship-to Address 2" := "Ship-to Address 2";
        PurchOrderHeader."Ship-to City" := "Ship-to City";
        PurchOrderHeader."Ship-to Post Code" := "Ship-to Post Code";
        PurchOrderHeader."Ship-to County" := "Ship-to County";
        PurchOrderHeader."Ship-to Country/Region Code" := "Ship-to Country/Region Code";
        PurchOrderHeader."Ship-to Contact" := "Ship-to Contact";

        PurchOrderHeader."Prepayment %" := Vend."Prepayment %";
        if PurchOrderHeader."Posting Date" = 0D then
          PurchOrderHeader."Posting Date" := WorkDate;

        PurchOrderHeader."Tax Area Code" := "Tax Area Code";
        PurchOrderHeader.Modify;

        PurchQuoteLine.SetRange("Document Type","Document Type");
        PurchQuoteLine.SetRange("Document No.","No.");

        if PurchQuoteLine.FindSet then
          repeat
            PurchOrderLine := PurchQuoteLine;
            PurchOrderLine."Document Type" := PurchOrderHeader."Document Type";
            PurchOrderLine."Document No." := PurchOrderHeader."No.";
            ReservePurchLine.TransferPurchLineToPurchLine(
              PurchQuoteLine,PurchOrderLine,PurchQuoteLine."Outstanding Qty. (Base)");
            PurchOrderLine."Shortcut Dimension 1 Code" := PurchQuoteLine."Shortcut Dimension 1 Code";
            PurchOrderLine."Shortcut Dimension 2 Code" := PurchQuoteLine."Shortcut Dimension 2 Code";
            PurchOrderLine."Dimension Set ID" := PurchQuoteLine."Dimension Set ID";
            if Vend."Prepayment %" <> 0 then
              PurchOrderLine."Prepayment %" := Vend."Prepayment %";
            PrepmtMgt.SetPurchPrepaymentPct(PurchOrderLine,PurchOrderHeader."Posting Date");
            PurchOrderLine.Validate("Prepayment %");
            PurchOrderLine.DefaultDeferralCode;

            PurchOrderLine.Insert;

            ReservePurchLine.VerifyQuantity(PurchOrderLine,PurchQuoteLine);
          until PurchQuoteLine.Next = 0;

        PurchSetup.Get;
        if PurchSetup."Archive Quotes and Orders" then
          ArchiveManagement.ArchPurchDocumentNoConfirm(Rec);

        if PurchSetup."Default Posting Date" = PurchSetup."default posting date"::"No Date" then begin
          PurchOrderHeader."Posting Date" := 0D;
          PurchOrderHeader.Modify;
        end;

        PurchCommentLine.SetRange("Document Type","Document Type");
        PurchCommentLine.SetRange("No.","No.");
        if not PurchCommentLine.IsEmpty then begin
          PurchCommentLine.LockTable;
          if PurchCommentLine.FindSet then
            repeat
              OldPurchCommentLine := PurchCommentLine;
              PurchCommentLine.Delete;
              PurchCommentLine."Document Type" := PurchOrderHeader."Document Type";
              PurchCommentLine."No." := PurchOrderHeader."No.";
              PurchCommentLine.Insert;
              PurchCommentLine := OldPurchCommentLine;
            until PurchCommentLine.Next = 0;
        end;
        RecordLinkManagement.CopyLinks(Rec,PurchOrderHeader);

        ItemChargeAssgntPurch.Reset;
        ItemChargeAssgntPurch.SetRange("Document Type","Document Type");
        ItemChargeAssgntPurch.SetRange("Document No.","No.");

        while ItemChargeAssgntPurch.FindFirst do begin
          ItemChargeAssgntPurch.Delete;
          ItemChargeAssgntPurch."Document Type" := PurchOrderHeader."Document Type";
          ItemChargeAssgntPurch."Document No." := PurchOrderHeader."No.";
          if not (ItemChargeAssgntPurch."Applies-to Doc. Type" in
                  [ItemChargeAssgntPurch."applies-to doc. type"::Receipt,
                   ItemChargeAssgntPurch."applies-to doc. type"::"Return Shipment"])
          then begin
            ItemChargeAssgntPurch."Applies-to Doc. Type" := PurchOrderHeader."Document Type";
            ItemChargeAssgntPurch."Applies-to Doc. No." := PurchOrderHeader."No.";
          end;
          ItemChargeAssgntPurch.Insert;
        end;

        ApprovalsMgmt.CopyApprovalEntryQuoteToOrder(Database::"Purchase Header","No.",PurchOrderHeader."No.",PurchOrderHeader.RecordId);
        ApprovalsMgmt.DeleteApprovalEntry(Rec);

        DeleteLinks;
        Delete;

        PurchQuoteLine.DeleteAll;

        if not ShouldRedistributeInvoiceAmount then
          PurchCalcDiscByType.ResetRecalculateInvoiceDisc(PurchOrderHeader);
        Commit;
    end;

    var
        PurchQuoteLine: Record "Purchase Line";
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
        PurchCommentLine: Record "Purch. Comment Line";
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        PurchSetup: Record "Purchases & Payables Setup";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        PrepmtMgt: Codeunit "Prepayment Mgt.";
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        ArchiveManagement: Codeunit ArchiveManagement;


    procedure GetPurchOrderHeader(var PurchHeader: Record "Purchase Header")
    begin
        PurchHeader := PurchOrderHeader;
    end;
}

