#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 415 "Release Purchase Document"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    begin
        PurchaseHeader.Copy(Rec);
        Code;
        Rec := PurchaseHeader;
    end;

    var
        Text001: label 'There is nothing to release for the document of type %1 with the number %2.';
        PurchSetup: Record "Purchases & Payables Setup";
        InvtSetup: Record "Inventory Setup";
        PurchaseHeader: Record "Purchase Header";
        WhsePurchRelease: Codeunit "Whse.-Purch. Release";
        Text002: label 'This document can only be released when the approval process is complete.';
        Text003: label 'The approval process must be canceled or completed to reopen this document.';
        Text005: label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        PreviewMode: Boolean;

    local procedure "Code"() LinesWereModified: Boolean
    var
        PurchLine: Record "Purchase Line";
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        NotOnlyDropShipment: Boolean;
        PostingDate: Date;
        PrintPostedDocuments: Boolean;
    begin
        with PurchaseHeader do begin
          if Status = Status::Released then
            exit;

          OnBeforeReleasePurchaseDoc(PurchaseHeader,PreviewMode);
          if not PreviewMode then
            OnCheckPurchaseReleaseRestrictions;

          TestField("Buy-from Vendor No.");

          PurchLine.SetRange("Document Type","Document Type");
          PurchLine.SetRange("Document No.","No.");
          PurchLine.SetFilter(Type,'>0');
          PurchLine.SetFilter(Quantity,'<>0');
          if not PurchLine.Find('-') then
            Error(Text001,"Document Type","No.");
          InvtSetup.Get;
          if InvtSetup."Location Mandatory" then begin
            PurchLine.SetRange(Type,PurchLine.Type::Item);
            if PurchLine.Find('-') then
              repeat
                if not PurchLine.IsServiceItem then
                  PurchLine.TestField("Location Code");
              until PurchLine.Next = 0;
            PurchLine.SetFilter(Type,'>0');
          end;
          PurchLine.SetRange("Drop Shipment",false);
          NotOnlyDropShipment := PurchLine.Find('-');
          PurchLine.Reset;

          PurchSetup.Get;
          if PurchSetup."Calc. Inv. Discount" then begin
            PostingDate := "Posting Date";
            PrintPostedDocuments := "Print Posted Documents";
            Codeunit.Run(Codeunit::"Purch.-Calc.Discount",PurchLine);
            LinesWereModified := true;
            Get("Document Type","No.");
            "Print Posted Documents" := PrintPostedDocuments;
            if PostingDate <> "Posting Date" then
              Validate("Posting Date",PostingDate);
          end;

          if PrepaymentMgt.TestPurchasePrepayment(PurchaseHeader) and ("Document Type" = "document type"::Order) then begin
            Status := Status::"Pending Prepayment";
            Modify(true);
            exit;
          end;
          Status := Status::Released;

          PurchLine.SetPurchHeader(PurchaseHeader);
          if "Tax Area Code" = '' then begin  // VAT
            PurchLine.CalcVATAmountLines(0,PurchaseHeader,PurchLine,TempVATAmountLine0);
            PurchLine.CalcVATAmountLines(1,PurchaseHeader,PurchLine,TempVATAmountLine1);
            LinesWereModified := LinesWereModified or
              PurchLine.UpdateVATOnLines(0,PurchaseHeader,PurchLine,TempVATAmountLine0) or
              PurchLine.UpdateVATOnLines(1,PurchaseHeader,PurchLine,TempVATAmountLine1);
          end else begin
            PurchLine.CalcSalesTaxLines(PurchaseHeader,PurchLine);
            LinesWereModified := true;
          end;

          Modify(true);

          if NotOnlyDropShipment then
            if "Document Type" in ["document type"::Order,"document type"::"Return Order"] then
              WhsePurchRelease.Release(PurchaseHeader);

          OnAfterReleasePurchaseDoc(PurchaseHeader,PreviewMode);
        end;
    end;


    procedure Reopen(var PurchHeader: Record "Purchase Header")
    begin
        OnBeforeReopenPurchaseDoc(PurchHeader);

        with PurchHeader do begin
          if Status = Status::Open then
            exit;
          if "Document Type" in ["document type"::Order,"document type"::"Return Order"] then
            WhsePurchRelease.Reopen(PurchHeader);
          Status := Status::Open;

          Modify(true);
        end;

        OnAfterReopenPurchaseDoc(PurchHeader);
    end;


    procedure PerformManualRelease(var PurchHeader: Record "Purchase Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        with PurchHeader do
          if ("Document Type" = "document type"::Order) and PrepaymentMgt.TestPurchasePayment(PurchHeader) then begin
            if Status <> Status::"Pending Prepayment" then begin
              Status := Status::"Pending Prepayment";
              Modify;
              Commit;
            end;
            Error(StrSubstNo(Text005,"Document Type","No."));
          end;

        if ApprovalsMgmt.IsPurchaseApprovalsWorkflowEnabled(PurchHeader) and (PurchHeader.Status = PurchHeader.Status::Open) then
          Error(Text002);

        Codeunit.Run(Codeunit::"Release Purchase Document",PurchHeader);
    end;


    procedure PerformManualReopen(var PurchHeader: Record "Purchase Header")
    begin
        if PurchHeader.Status = PurchHeader.Status::"Pending Approval" then
          Error(Text003);

        Reopen(PurchHeader);
    end;


    procedure ReleasePurchaseHeader(var PurchHdr: Record "Purchase Header";Preview: Boolean) LinesWereModified: Boolean
    begin
        PreviewMode := Preview;
        PurchaseHeader.Copy(PurchHdr);
        LinesWereModified := Code;
        PurchHdr := PurchaseHeader;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header";PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header";PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReopenPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    begin
    end;


    procedure ReleaseSpecialExams(var SpecialExams: Record UnknownRecord78002)
    begin
        SpecialExams."Approval Status":=SpecialExams."approval status"::Pending;
        SpecialExams.Modify();
    end;


    procedure ReOPenSpecialExams(var SpecialExams: Record UnknownRecord78002)
    begin
        SpecialExams."Approval Status":=SpecialExams."approval status"::Open;
        SpecialExams.Modify();
    end;
}

