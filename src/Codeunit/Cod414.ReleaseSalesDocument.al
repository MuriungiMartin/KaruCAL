#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 414 "Release Sales Document"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        SalesHeader.Copy(Rec);
        Code;
        Rec := SalesHeader;
    end;

    var
        Text001: label 'There is nothing to release for the document of type %1 with the number %2.';
        SalesSetup: Record "Sales & Receivables Setup";
        InvtSetup: Record "Inventory Setup";
        SalesHeader: Record "Sales Header";
        WhseSalesRelease: Codeunit "Whse.-Sales Release";
        Text002: label 'This document can only be released when the approval process is complete.';
        Text003: label 'The approval process must be canceled or completed to reopen this document.';
        Text005: label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        PreviewMode: Boolean;

    local procedure "Code"() LinesWereModified: Boolean
    var
        SalesLine: Record "Sales Line";
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        NotOnlyDropShipment: Boolean;
        PostingDate: Date;
        PrintPostedDocuments: Boolean;
    begin
        with SalesHeader do begin
          if Status = Status::Released then
            exit;

          OnBeforeReleaseSalesDoc(SalesHeader,PreviewMode);
          if not PreviewMode then
            OnCheckSalesReleaseRestrictions;

          if "Document Type" = "document type"::Quote then
            if CheckCustomerCreated(true) then
              Get("document type"::Quote,"No.")
            else
              exit;

          TestField("Sell-to Customer No.");

          SalesLine.SetRange("Document Type","Document Type");
          SalesLine.SetRange("Document No.","No.");
          SalesLine.SetFilter(Type,'>0');
          SalesLine.SetFilter(Quantity,'<>0');
          if not SalesLine.Find('-') then
            Error(Text001,"Document Type","No.");
          InvtSetup.Get;
          if InvtSetup."Location Mandatory" then begin
            SalesLine.SetRange(Type,SalesLine.Type::Item);
            if SalesLine.FindSet then
              repeat
                if not SalesLine.IsServiceItem then
                  SalesLine.TestField("Location Code");
              until SalesLine.Next = 0;
            SalesLine.SetFilter(Type,'>0');
          end;
          SalesLine.SetRange("Drop Shipment",false);
          NotOnlyDropShipment := SalesLine.FindFirst;
          SalesLine.Reset;

          SalesSetup.Get;
          if SalesSetup."Calc. Inv. Discount" then begin
            PostingDate := "Posting Date";
            PrintPostedDocuments := "Print Posted Documents";
            Codeunit.Run(Codeunit::"Sales-Calc. Discount",SalesLine);
            LinesWereModified := true;
            Get("Document Type","No.");
            "Print Posted Documents" := PrintPostedDocuments;
            if PostingDate <> "Posting Date" then
              Validate("Posting Date",PostingDate);
          end;

          if PrepaymentMgt.TestSalesPrepayment(SalesHeader) and ("Document Type" = "document type"::Order) then begin
            Status := Status::"Pending Prepayment";
            Modify(true);
            exit;
          end;
          Status := Status::Released;

          SalesLine.SetSalesHeader(SalesHeader);
          if "Tax Area Code" = '' then begin  // VAT
            SalesLine.CalcVATAmountLines(0,SalesHeader,SalesLine,TempVATAmountLine0);
            SalesLine.CalcVATAmountLines(1,SalesHeader,SalesLine,TempVATAmountLine1);
            LinesWereModified := LinesWereModified or
              SalesLine.UpdateVATOnLines(0,SalesHeader,SalesLine,TempVATAmountLine0) or
              SalesLine.UpdateVATOnLines(1,SalesHeader,SalesLine,TempVATAmountLine1);
          end else begin
            SalesLine.CalcSalesTaxLines(SalesHeader,SalesLine);
            LinesWereModified := true;
          end;
          ReleaseATOs(SalesHeader);
          OnAfterReleaseATOs(SalesHeader,SalesLine);

          Modify(true);

          if NotOnlyDropShipment then
            if "Document Type" in ["document type"::Order,"document type"::"Return Order"] then
              WhseSalesRelease.Release(SalesHeader);

          OnAfterReleaseSalesDoc(SalesHeader,PreviewMode);
        end;
    end;


    procedure Reopen(var SalesHeader: Record "Sales Header")
    begin
        OnBeforeReopenSalesDoc(SalesHeader);

        with SalesHeader do begin
          if Status = Status::Open then
            exit;
          Status := Status::Open;

          if "Document Type" <> "document type"::Order then
            ReopenATOs(SalesHeader);

          Modify(true);
          if "Document Type" in ["document type"::Order,"document type"::"Return Order"] then
            WhseSalesRelease.Reopen(SalesHeader);
        end;

        OnAfterReopenSalesDoc(SalesHeader);
    end;


    procedure PerformManualRelease(var SalesHeader: Record "Sales Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        with SalesHeader do
          if ("Document Type" = "document type"::Order) and PrepaymentMgt.TestSalesPayment(SalesHeader) then begin
            if Status <> Status::"Pending Prepayment" then begin
              Status := Status::"Pending Prepayment";
              Modify;
              Commit;
            end;
            Error(StrSubstNo(Text005,"Document Type","No."));
          end;

        if ApprovalsMgmt.IsSalesApprovalsWorkflowEnabled(SalesHeader) and (SalesHeader.Status = SalesHeader.Status::Open) then
          Error(Text002);

        Codeunit.Run(Codeunit::"Release Sales Document",SalesHeader);
    end;


    procedure PerformManualReopen(var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader.Status = SalesHeader.Status::"Pending Approval" then
          Error(Text003);

        Reopen(SalesHeader);
    end;

    local procedure ReleaseATOs(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        AsmHeader: Record "Assembly Header";
    begin
        SalesLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        if SalesLine.FindSet then
          repeat
            if SalesLine.AsmToOrderExists(AsmHeader) then
              Codeunit.Run(Codeunit::"Release Assembly Document",AsmHeader);
          until SalesLine.Next = 0;
    end;

    local procedure ReopenATOs(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        AsmHeader: Record "Assembly Header";
        ReleaseAssemblyDocument: Codeunit "Release Assembly Document";
    begin
        SalesLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        if SalesLine.FindSet then
          repeat
            if SalesLine.AsmToOrderExists(AsmHeader) then
              ReleaseAssemblyDocument.Reopen(AsmHeader);
          until SalesLine.Next = 0;
    end;


    procedure ReleaseSalesHeader(var SalesHdr: Record "Sales Header";Preview: Boolean) LinesWereModified: Boolean
    begin
        PreviewMode := Preview;
        SalesHeader.Copy(SalesHdr);
        LinesWereModified := Code;
        SalesHdr := SalesHeader;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header";PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header";PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenSalesDoc(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReopenSalesDoc(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseATOs(var SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line")
    begin
    end;
}

