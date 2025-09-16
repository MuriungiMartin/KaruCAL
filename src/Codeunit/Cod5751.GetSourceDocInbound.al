#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5751 "Get Source Doc. Inbound"
{

    trigger OnRun()
    begin
    end;

    var
        GetSourceDocuments: Report "Get Source Documents";

    local procedure CreateWhseReceiptHeaderFromWhseRequest(var WarehouseRequest: Record "Warehouse Request"): Boolean
    begin
        if WarehouseRequest.IsEmpty then
          exit(false);

        Clear(GetSourceDocuments);
        GetSourceDocuments.UseRequestPage(false);
        GetSourceDocuments.SetTableview(WarehouseRequest);
        GetSourceDocuments.SetHideDialog(true);
        GetSourceDocuments.RunModal;

        exit(true);
    end;


    procedure GetInboundDocs(WhseReceiptHeader: Record "Warehouse Receipt Header")
    var
        WhseGetSourceFilterRec: Record "Warehouse Source Filter";
        WhseSourceFilterSelection: Page "Filters to Get Source Docs.";
    begin
        WhseReceiptHeader.Find;
        WhseSourceFilterSelection.SetOneCreatedReceiptHeader(WhseReceiptHeader);
        WhseGetSourceFilterRec.FilterGroup(2);
        WhseGetSourceFilterRec.SetRange(Type,WhseGetSourceFilterRec.Type::Inbound);
        WhseGetSourceFilterRec.FilterGroup(0);
        WhseSourceFilterSelection.SetTableview(WhseGetSourceFilterRec);
        WhseSourceFilterSelection.RunModal;
    end;


    procedure GetSingleInboundDoc(WhseReceiptHeader: Record "Warehouse Receipt Header")
    var
        WhseRqst: Record "Warehouse Request";
        SourceDocSelection: Page "Source Documents";
    begin
        Clear(GetSourceDocuments);
        WhseReceiptHeader.Find;

        WhseRqst.FilterGroup(2);
        WhseRqst.SetRange(Type,WhseRqst.Type::Inbound);
        WhseRqst.SetRange("Location Code",WhseReceiptHeader."Location Code");
        WhseRqst.FilterGroup(0);
        WhseRqst.SetRange("Document Status",WhseRqst."document status"::Released);
        WhseRqst.SetRange("Completely Handled",false);

        SourceDocSelection.LookupMode(true);
        SourceDocSelection.SetTableview(WhseRqst);
        if SourceDocSelection.RunModal <> Action::LookupOK then
          exit;
        SourceDocSelection.GetResult(WhseRqst);

        GetSourceDocuments.SetOneCreatedReceiptHeader(WhseReceiptHeader);
        GetSourceDocuments.UseRequestPage(false);
        GetSourceDocuments.SetTableview(WhseRqst);
        GetSourceDocuments.RunModal;
    end;


    procedure CreateFromPurchOrder(PurchHeader: Record "Purchase Header")
    begin
        ShowDialog(CreateFromPurchOrderHideDialog(PurchHeader));
    end;


    procedure CreateFromPurchOrderHideDialog(PurchHeader: Record "Purchase Header"): Boolean
    var
        WhseRqst: Record "Warehouse Request";
    begin
        FindWarehouseRequestForPurchaseOrder(WhseRqst,PurchHeader);
        exit(CreateWhseReceiptHeaderFromWhseRequest(WhseRqst));
    end;


    procedure CreateFromSalesReturnOrder(SalesHeader: Record "Sales Header")
    begin
        ShowDialog(CreateFromSalesReturnOrderHideDialog(SalesHeader));
    end;


    procedure CreateFromSalesReturnOrderHideDialog(SalesHeader: Record "Sales Header"): Boolean
    var
        WhseRqst: Record "Warehouse Request";
    begin
        FindWarehouseRequestForSalesReturnOrder(WhseRqst,SalesHeader);
        exit(CreateWhseReceiptHeaderFromWhseRequest(WhseRqst));
    end;


    procedure CreateFromInbndTransferOrder(TransHeader: Record "Transfer Header")
    begin
        ShowDialog(CreateFromInbndTransferOrderHideDialog(TransHeader));
    end;


    procedure CreateFromInbndTransferOrderHideDialog(TransHeader: Record "Transfer Header"): Boolean
    var
        WhseRqst: Record "Warehouse Request";
    begin
        FindWarehouseRequestForInbndTransferOrder(WhseRqst,TransHeader);
        exit(CreateWhseReceiptHeaderFromWhseRequest(WhseRqst));
    end;


    procedure GetSingleWhsePutAwayDoc(CurrentWkshTemplateName: Code[10];CurrentWkshName: Code[10];LocationCode: Code[10])
    var
        WhsePutAwayRqst: Record "Whse. Put-away Request";
        GetWhseSourceDocuments: Report "Get Inbound Source Documents";
        WhsePutAwayDocSelection: Page "Put-away Selection";
    begin
        WhsePutAwayRqst.FilterGroup(2);
        WhsePutAwayRqst.SetRange("Completely Put Away",false);
        WhsePutAwayRqst.SetRange("Location Code",LocationCode);
        WhsePutAwayRqst.FilterGroup(0);

        WhsePutAwayDocSelection.LookupMode(true);
        WhsePutAwayDocSelection.SetTableview(WhsePutAwayRqst);
        if WhsePutAwayDocSelection.RunModal <> Action::LookupOK then
          exit;

        WhsePutAwayDocSelection.GetResult(WhsePutAwayRqst);

        GetWhseSourceDocuments.SetWhseWkshName(
          CurrentWkshTemplateName,CurrentWkshName,LocationCode);

        GetWhseSourceDocuments.UseRequestPage(false);
        GetWhseSourceDocuments.SetTableview(WhsePutAwayRqst);
        GetWhseSourceDocuments.RunModal;
    end;

    local procedure GetRequireReceiveRqst(var WhseRqst: Record "Warehouse Request")
    var
        Location: Record Location;
        LocationCode: Text;
    begin
        if WhseRqst.FindSet then begin
          repeat
            if Location.RequireReceive(WhseRqst."Location Code") then
              LocationCode += WhseRqst."Location Code" + '|';
          until WhseRqst.Next = 0;
          if LocationCode <> '' then
            LocationCode := CopyStr(LocationCode,1,StrLen(LocationCode) - 1);
          WhseRqst.SetFilter("Location Code",LocationCode);
        end;
    end;

    local procedure FindWarehouseRequestForPurchaseOrder(var WhseRqst: Record "Warehouse Request";PurchHeader: Record "Purchase Header")
    begin
        with PurchHeader do begin
          TestField(Status,Status::Released);
          WhseRqst.SetRange(Type,WhseRqst.Type::Inbound);
          WhseRqst.SetRange("Source Type",Database::"Purchase Line");
          WhseRqst.SetRange("Source Subtype","Document Type");
          WhseRqst.SetRange("Source No.","No.");
          WhseRqst.SetRange("Document Status",WhseRqst."document status"::Released);
          GetRequireReceiveRqst(WhseRqst);
        end;
    end;

    local procedure FindWarehouseRequestForSalesReturnOrder(var WhseRqst: Record "Warehouse Request";SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do begin
          TestField(Status,Status::Released);
          WhseRqst.SetRange(Type,WhseRqst.Type::Inbound);
          WhseRqst.SetRange("Source Type",Database::"Sales Line");
          WhseRqst.SetRange("Source Subtype","Document Type");
          WhseRqst.SetRange("Source No.","No.");
          WhseRqst.SetRange("Document Status",WhseRqst."document status"::Released);
          GetRequireReceiveRqst(WhseRqst);
        end;
    end;

    local procedure FindWarehouseRequestForInbndTransferOrder(var WhseRqst: Record "Warehouse Request";TransHeader: Record "Transfer Header")
    begin
        with TransHeader do begin
          TestField(Status,Status::Released);
          WhseRqst.SetRange(Type,WhseRqst.Type::Inbound);
          WhseRqst.SetRange("Source Type",Database::"Transfer Line");
          WhseRqst.SetRange("Source Subtype",1);
          WhseRqst.SetRange("Source No.","No.");
          WhseRqst.SetRange("Document Status",WhseRqst."document status"::Released);
          GetRequireReceiveRqst(WhseRqst);
        end;
    end;

    local procedure OpenWarehouseReceiptPage()
    var
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
    begin
        GetSourceDocuments.GetLastReceiptHeader(WarehouseReceiptHeader);
        Page.Run(Page::"Warehouse Receipt",WarehouseReceiptHeader);
    end;

    local procedure ShowDialog(WhseReceiptCreated: Boolean)
    begin
        GetSourceDocuments.ShowReceiptDialog;
        if WhseReceiptCreated then
          OpenWarehouseReceiptPage;
    end;
}

