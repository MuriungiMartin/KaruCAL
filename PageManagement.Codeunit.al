#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 700 "Page Management"
{

    trigger OnRun()
    begin
    end;

    var
        DataTypeManagement: Codeunit "Data Type Management";


    procedure PageRun(RecRelatedVariant: Variant): Boolean
    var
        RecordRef: RecordRef;
        RecordRefVariant: Variant;
        PageID: Integer;
    begin
        if not GuiAllowed then
          exit(false);

        if not DataTypeManagement.GetRecordRef(RecRelatedVariant,RecordRef) then
          exit(false);

        PageID := GetPageID(RecordRef);

        if PageID <> 0 then begin
          RecordRefVariant := RecordRef;
          Page.Run(PageID,RecordRefVariant);
          exit(true);
        end;

        exit(false);
    end;


    procedure PageRunModal(RecRelatedVariant: Variant): Boolean
    var
        RecordRef: RecordRef;
        RecordRefVariant: Variant;
        PageID: Integer;
    begin
        if not GuiAllowed then
          exit(false);

        if not DataTypeManagement.GetRecordRef(RecRelatedVariant,RecordRef) then
          exit(false);

        PageID := GetPageID(RecordRef);

        if PageID <> 0 then begin
          RecordRefVariant := RecordRef;
          Page.RunModal(PageID,RecordRefVariant);
          exit(true);
        end;

        exit(false);
    end;


    procedure PageRunModalWithFieldFocus(RecRelatedVariant: Variant;FieldNumber: Integer): Boolean
    var
        RecordRef: RecordRef;
        RecordRefVariant: Variant;
        PageID: Integer;
    begin
        if not GuiAllowed then
          exit(false);

        if not DataTypeManagement.GetRecordRef(RecRelatedVariant,RecordRef) then
          exit(false);

        PageID := GetPageID(RecordRef);

        if PageID <> 0 then begin
          RecordRefVariant := RecordRef;
          Page.RunModal(PageID,RecordRefVariant,FieldNumber);
          exit(true);
        end;

        exit(false);
    end;


    procedure GetPageID(RecRelatedVariant: Variant): Integer
    var
        RecordRef: RecordRef;
        EmptyRecRef: RecordRef;
        PageID: Integer;
    begin
        if not DataTypeManagement.GetRecordRef(RecRelatedVariant,RecordRef) then
          exit;

        EmptyRecRef.Open(RecordRef.Number);
        PageID := GetConditionalCardPageID(RecordRef);
        // Choose default card only if record exists
        if RecordRef.RecordId <> EmptyRecRef.RecordId then
          if PageID = 0 then
            PageID := GetDefaultCardPageID(RecordRef.Number);

        if PageID = 0 then
          PageID := GetDefaultLookupPageID(RecordRef.Number);

        exit(PageID);
    end;


    procedure GetDefaultCardPageID(TableID: Integer): Integer
    var
        PageMetadata: Record "Page Metadata";
        LookupPageID: Integer;
    begin
        if TableID = 0 then
          exit(0);

        LookupPageID := GetDefaultLookupPageID(TableID);
        if LookupPageID <> 0 then begin
          PageMetadata.Get(LookupPageID);
          if PageMetadata.CardPageID <> 0 then
            exit(PageMetadata.CardPageID);
        end;
        exit(0);
    end;


    procedure GetDefaultLookupPageID(TableID: Integer): Integer
    var
        TableMetadata: Record "Table Metadata";
    begin
        if TableID = 0 then
          exit(0);

        TableMetadata.Get(TableID);
        exit(TableMetadata.LookupPageID);
    end;


    procedure GetConditionalCardPageID(RecordRef: RecordRef): Integer
    begin
        case RecordRef.Number of
          Database::"Company Information":
            exit(Page::"Company Information");
          Database::"Sales Header":
            exit(GetSalesHeaderPageID(RecordRef));
          Database::"Purchase Header":
            exit(GetPurchaseHeaderPageID(RecordRef));
          Database::"Service Header":
            exit(GetServiceHeaderPageID(RecordRef));
          Database::"Gen. Journal Batch":
            exit(GetGenJournalBatchPageID(RecordRef));
          Database::"Gen. Journal Line":
            exit(GetGenJournalLinePageID(RecordRef));
          Database::"Sales Header Archive":
            exit(GetSalesHeaderArchivePageID(RecordRef));
          Database::"Purchase Header Archive":
            exit(GetPurchaseHeaderArchivePageID(RecordRef));
          Database::"Res. Journal Line":
            exit(Page::"Resource Journal");
          Database::"Job Journal Line":
            exit(Page::"Job Journal");
          Database::"Item Analysis View":
            exit(GetAnalysisViewPageID(RecordRef));
          Database::"Purchases & Payables Setup":
            exit(Page::"Purchases & Payables Setup");
          Database::"Approval Entry":
            exit(GetApprovalEntryPageID(RecordRef));
          Database::"Doc. Exch. Service Setup":
            exit(Page::"Doc. Exch. Service Setup");
          Database::"Incoming Documents Setup":
            exit(Page::"Incoming Documents Setup");
          Database::"Text-to-Account Mapping":
            exit(Page::"Text-to-Account Mapping Wksh.");
          Database::"Cash Flow Setup":
            exit(Page::"Cash Flow Setup");
          Database::"Aca-Special Exams Details":
            exit(Page::"Special Exams Details List");
        end;
        exit(0);
    end;

    local procedure GetSalesHeaderPageID(RecordRef: RecordRef): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        RecordRef.SetTable(SalesHeader);
        case SalesHeader."Document Type" of
          SalesHeader."document type"::Quote:
            exit(Page::"Sales Quote");
          SalesHeader."document type"::Order:
            exit(Page::"Sales Order");
          SalesHeader."document type"::Invoice:
            exit(Page::"Sales Invoice");
          SalesHeader."document type"::"Credit Memo":
            exit(Page::"Sales Credit Memo");
          SalesHeader."document type"::"Blanket Order":
            exit(Page::"Blanket Sales Order");
          SalesHeader."document type"::"Return Order":
            exit(Page::"Sales Return Order");
        end;
    end;

    local procedure GetPurchaseHeaderPageID(RecordRef: RecordRef): Integer
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        RecordRef.SetTable(PurchaseHeader);
        case PurchaseHeader."Document Type" of
          PurchaseHeader."document type"::Quote:
            exit(Page::"Purchase Quote");
          PurchaseHeader."document type"::Order:
            exit(Page::"Purchase Order");
          PurchaseHeader."document type"::Invoice:
            exit(Page::"Purchase Invoice");
          PurchaseHeader."document type"::"Credit Memo":
            exit(Page::"Purchase Credit Memo");
          PurchaseHeader."document type"::"Blanket Order":
            exit(Page::"Blanket Purchase Order");
          PurchaseHeader."document type"::"Return Order":
            exit(Page::"Purchase Return Order");
        end;
    end;

    local procedure GetServiceHeaderPageID(RecordRef: RecordRef): Integer
    var
        ServiceHeader: Record "Service Header";
    begin
        RecordRef.SetTable(ServiceHeader);
        case ServiceHeader."Document Type" of
          ServiceHeader."document type"::Quote:
            exit(Page::"Service Quote");
          ServiceHeader."document type"::Order:
            exit(Page::"Service Order");
          ServiceHeader."document type"::Invoice:
            exit(Page::"Service Invoice");
          ServiceHeader."document type"::"Credit Memo":
            exit(Page::"Service Credit Memo");
        end;
    end;

    local procedure GetGenJournalBatchPageID(RecordRef: RecordRef): Integer
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
    begin
        RecordRef.SetTable(GenJournalBatch);

        GenJournalLine.SetRange("Journal Template Name",GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name",GenJournalBatch.Name);
        if not GenJournalLine.FindFirst then
          exit(Page::"General Journal");

        RecordRef.GetTable(GenJournalLine);
        exit(GetGenJournalLinePageID(RecordRef));
    end;

    local procedure GetGenJournalLinePageID(RecordRef: RecordRef): Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        RecordRef.SetTable(GenJournalLine);
        GenJournalTemplate.Get(GenJournalLine."Journal Template Name");
        if GenJournalTemplate.Recurring then
          exit(Page::"Recurring General Journal");
        case GenJournalTemplate.Type of
          GenJournalTemplate.Type::General:
            exit(Page::"General Journal");
          GenJournalTemplate.Type::Sales:
            exit(Page::"Sales Journal");
          GenJournalTemplate.Type::Purchases:
            exit(Page::"Purchase Journal");
          GenJournalTemplate.Type::"Cash Receipts":
            exit(Page::"Cash Receipt Journal");
          GenJournalTemplate.Type::Payments:
            exit(Page::"Payment Journal");
          GenJournalTemplate.Type::Assets:
            exit(Page::"Fixed Asset G/L Journal");
          GenJournalTemplate.Type::Intercompany:
            exit(Page::"IC General Journal");
          GenJournalTemplate.Type::Jobs:
            exit(Page::"Job G/L Journal");
        end;
    end;

    local procedure GetSalesHeaderArchivePageID(RecordRef: RecordRef): Integer
    var
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        RecordRef.SetTable(SalesHeaderArchive);
        case SalesHeaderArchive."Document Type" of
          SalesHeaderArchive."document type"::Quote:
            exit(Page::"Sales Quote Archive");
          SalesHeaderArchive."document type"::Order:
            exit(Page::"Sales Order Archive");
          SalesHeaderArchive."document type"::"Return Order":
            exit(Page::"Sales Return Order Archive");
        end;
    end;

    local procedure GetPurchaseHeaderArchivePageID(RecordRef: RecordRef): Integer
    var
        PurchaseHeaderArchive: Record "Purchase Header Archive";
    begin
        RecordRef.SetTable(PurchaseHeaderArchive);
        case PurchaseHeaderArchive."Document Type" of
          PurchaseHeaderArchive."document type"::Quote:
            exit(Page::"Purchase Quote Archive");
          PurchaseHeaderArchive."document type"::Order:
            exit(Page::"Purchase Order Archive");
          PurchaseHeaderArchive."document type"::"Return Order":
            exit(Page::"Purchase Return Order Archive");
        end;
    end;

    local procedure GetAnalysisViewPageID(RecordRef: RecordRef): Integer
    var
        ItemAnalysisView: Record "Item Analysis View";
    begin
        RecordRef.SetTable(ItemAnalysisView);
        case ItemAnalysisView."Analysis Area" of
          ItemAnalysisView."analysis area"::Sales:
            exit(Page::"Sales Analysis View Card");
          ItemAnalysisView."analysis area"::Purchase:
            exit(Page::"Purchase Analysis View Card");
          ItemAnalysisView."analysis area"::Inventory:
            exit(Page::"Invt. Analysis View Card");
        end;
    end;

    local procedure GetApprovalEntryPageID(RecordRef: RecordRef): Integer
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        RecordRef.SetTable(ApprovalEntry);
        case ApprovalEntry.Status of
          ApprovalEntry.Status::Open:
            exit(Page::"Requests to Approve");
          else
            exit(Page::"Approval Entries");
        end;
    end;


    procedure GetRTCUrl(var RecRef: RecordRef;PageID: Integer): Text
    begin
        if not RecRef.HasFilter then
          RecRef.SetRecfilter;

        if not VerifyPageID(RecRef.Number,PageID) then
          PageID := GetPageID(RecRef);

        exit(GetUrl(Clienttype::Windows,COMPANYNAME,Objecttype::Page,PageID,RecRef,false));
    end;


    procedure GetWebUrl(var RecRef: RecordRef;PageID: Integer): Text
    begin
        if not RecRef.HasFilter then
          RecRef.SetRecfilter;

        if not VerifyPageID(RecRef.Number,PageID) then
          PageID := GetPageID(RecRef);

        exit(GetUrl(Clienttype::Web,COMPANYNAME,Objecttype::Page,PageID,RecRef,false));
    end;

    local procedure VerifyPageID(TableID: Integer;PageID: Integer): Boolean
    var
        PageMetadata: Record "Page Metadata";
    begin
        exit(PageMetadata.Get(PageID) and (PageMetadata.SourceTable = TableID));
    end;
}

