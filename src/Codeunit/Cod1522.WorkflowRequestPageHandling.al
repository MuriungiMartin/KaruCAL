#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1522 "Workflow Request Page Handling"
{

    trigger OnRun()
    begin
    end;

    var
        PurchaseDocumentCodeTxt: label 'PURCHDOC', Locked=true;
        PurchaseDocumentDescTxt: label 'Purchase Document';
        SalesDocumentCodeTxt: label 'SALESDOC', Locked=true;
        SalesDocumentDescTxt: label 'Sales Document';
        IncomingDocumentCodeTxt: label 'INCOMINGDOC', Locked=true;
        IncomingDocumentDescTxt: label 'Incoming Document';


    procedure CreateEntitiesAndFields()
    begin
        InsertRequestPageEntities;
        InsertRequestPageFields;
    end;


    procedure AssignEntitiesToWorkflowEvents()
    begin
        AssignEntityToWorkflowEvent(Database::"Purchase Header",PurchaseDocumentCodeTxt);
        AssignEntityToWorkflowEvent(Database::"Sales Header",SalesDocumentCodeTxt);
        AssignEntityToWorkflowEvent(Database::"Incoming Document Attachment",IncomingDocumentCodeTxt);
        AssignEntityToWorkflowEvent(Database::"Incoming Document",IncomingDocumentCodeTxt);
    end;

    local procedure InsertRequestPageEntities()
    begin
        InsertReqPageEntity(
          PurchaseDocumentCodeTxt,PurchaseDocumentDescTxt,Database::"Purchase Header",Database::"Purchase Line");
        InsertReqPageEntity(
          SalesDocumentCodeTxt,SalesDocumentDescTxt,Database::"Sales Header",Database::"Sales Line");
        InsertReqPageEntity(
          IncomingDocumentCodeTxt,IncomingDocumentDescTxt,Database::"Incoming Document Attachment",Database::"Incoming Document");
        InsertReqPageEntity(
          IncomingDocumentCodeTxt,IncomingDocumentDescTxt,Database::"Incoming Document",Database::"Incoming Document Attachment");
    end;

    local procedure InsertReqPageEntity(Name: Code[20];Description: Text[100];TableId: Integer;RelatedTableId: Integer)
    begin
        if not FindReqPageEntity(Name,TableId,RelatedTableId) then
          CreateReqPageEntity(Name,Description,TableId,RelatedTableId);
    end;

    local procedure FindReqPageEntity(Name: Code[20];TableId: Integer;RelatedTableId: Integer): Boolean
    var
        DynamicRequestPageEntity: Record "Dynamic Request Page Entity";
    begin
        DynamicRequestPageEntity.SetRange(Name,Name);
        DynamicRequestPageEntity.SetRange("Table ID",TableId);
        DynamicRequestPageEntity.SetRange("Related Table ID",RelatedTableId);
        exit(DynamicRequestPageEntity.FindFirst);
    end;

    local procedure CreateReqPageEntity(Name: Code[20];Description: Text[100];TableId: Integer;RelatedTableId: Integer)
    var
        DynamicRequestPageEntity: Record "Dynamic Request Page Entity";
    begin
        DynamicRequestPageEntity.Init;
        DynamicRequestPageEntity.Name := Name;
        DynamicRequestPageEntity.Description := Description;
        DynamicRequestPageEntity.Validate("Table ID",TableId);
        DynamicRequestPageEntity.Validate("Related Table ID",RelatedTableId);
        DynamicRequestPageEntity.Insert(true);
    end;

    local procedure InsertRequestPageFields()
    begin
        InsertIncomingDocumentReqPageFields;

        InsertPurchaseHeaderReqPageFields;
        InsertPurchaseLineReqPageFields;

        InsertSalesHeaderReqPageFields;
        InsertSalesLineReqPageFields;

        InsertCustomerReqPageFields;
        InsertVendorReqPageFields;

        InsertItemReqPageFields;
        InsertGeneralJournalBatchReqPageFields;
        InsertGeneralJournalLineReqPageFields;

        InsertApprovalEntryReqPageFields;
    end;

    local procedure InsertIncomingDocumentReqPageFields()
    var
        IncomingDocument: Record "Incoming Document";
    begin
        InsertReqPageField(Database::"Incoming Document",IncomingDocument.FieldNo("Created By User ID"));
        InsertReqPageField(Database::"Incoming Document",IncomingDocument.FieldNo(Posted));
        InsertReqPageField(Database::"Incoming Document",IncomingDocument.FieldNo(Status));
    end;

    local procedure InsertPurchaseHeaderReqPageFields()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        InsertReqPageField(Database::"Purchase Header",PurchaseHeader.FieldNo("Buy-from Vendor No."));
        InsertReqPageField(Database::"Purchase Header",PurchaseHeader.FieldNo("Payment Terms Code"));
        InsertReqPageField(Database::"Purchase Header",PurchaseHeader.FieldNo(Amount));
        InsertReqPageField(Database::"Purchase Header",PurchaseHeader.FieldNo("Currency Code"));
    end;

    local procedure InsertPurchaseLineReqPageFields()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        InsertReqPageField(Database::"Purchase Line",PurchaseLine.FieldNo(Type));
        InsertReqPageField(Database::"Purchase Line",PurchaseLine.FieldNo("No."));
        InsertReqPageField(Database::"Purchase Line",PurchaseLine.FieldNo(Quantity));
        InsertReqPageField(Database::"Purchase Line",PurchaseLine.FieldNo("Direct Unit Cost"));
    end;

    local procedure InsertSalesHeaderReqPageFields()
    var
        SalesHeader: Record "Sales Header";
    begin
        InsertReqPageField(Database::"Sales Header",SalesHeader.FieldNo("Sell-to Customer No."));
        InsertReqPageField(Database::"Sales Header",SalesHeader.FieldNo("Payment Terms Code"));
        InsertReqPageField(Database::"Sales Header",SalesHeader.FieldNo(Amount));
        InsertReqPageField(Database::"Sales Header",SalesHeader.FieldNo("Currency Code"));
    end;

    local procedure InsertSalesLineReqPageFields()
    var
        SalesLine: Record "Sales Line";
    begin
        InsertReqPageField(Database::"Sales Line",SalesLine.FieldNo(Type));
        InsertReqPageField(Database::"Sales Line",SalesLine.FieldNo("No."));
        InsertReqPageField(Database::"Sales Line",SalesLine.FieldNo(Quantity));
        InsertReqPageField(Database::"Sales Line",SalesLine.FieldNo("Unit Cost"));
    end;

    local procedure InsertCustomerReqPageFields()
    var
        Customer: Record Customer;
    begin
        InsertReqPageField(Database::Customer,Customer.FieldNo("No."));
        InsertReqPageField(Database::Customer,Customer.FieldNo(Blocked));
        InsertReqPageField(Database::Customer,Customer.FieldNo("Credit Limit (LCY)"));
        InsertReqPageField(Database::Customer,Customer.FieldNo("Payment Method Code"));
        InsertReqPageField(Database::Customer,Customer.FieldNo("Gen. Bus. Posting Group"));
        InsertReqPageField(Database::Customer,Customer.FieldNo("Customer Posting Group"));
    end;

    local procedure InsertItemReqPageFields()
    var
        Item: Record Item;
    begin
        InsertReqPageField(Database::Item,Item.FieldNo("No."));
        InsertReqPageField(Database::Item,Item.FieldNo("Item Category Code"));
        InsertReqPageField(Database::Item,Item.FieldNo("Unit Price"));
    end;

    local procedure InsertGeneralJournalBatchReqPageFields()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        InsertReqPageField(Database::"Gen. Journal Batch",GenJournalBatch.FieldNo(Name));
        InsertReqPageField(Database::"Gen. Journal Batch",GenJournalBatch.FieldNo("Template Type"));
        InsertReqPageField(Database::"Gen. Journal Batch",GenJournalBatch.FieldNo(Recurring));
    end;

    local procedure InsertGeneralJournalLineReqPageFields()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        InsertReqPageField(Database::"Gen. Journal Line",GenJournalLine.FieldNo("Document Type"));
        InsertReqPageField(Database::"Gen. Journal Line",GenJournalLine.FieldNo("Account Type"));
        InsertReqPageField(Database::"Gen. Journal Line",GenJournalLine.FieldNo("Account No."));
        InsertReqPageField(Database::"Gen. Journal Line",GenJournalLine.FieldNo(Amount));
    end;

    local procedure InsertApprovalEntryReqPageFields()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        InsertReqPageField(Database::"Approval Entry",ApprovalEntry.FieldNo("Pending Approvals"));
    end;

    local procedure InsertReqPageField(TableId: Integer;FieldId: Integer)
    var
        DynamicRequestPageField: Record "Dynamic Request Page Field";
    begin
        if not DynamicRequestPageField.Get(TableId,FieldId) then
          CreateReqPageField(TableId,FieldId);
    end;

    local procedure CreateReqPageField(TableId: Integer;FieldId: Integer)
    var
        DynamicRequestPageField: Record "Dynamic Request Page Field";
    begin
        DynamicRequestPageField.Init;
        DynamicRequestPageField.Validate("Table ID",TableId);
        DynamicRequestPageField.Validate("Field ID",FieldId);
        DynamicRequestPageField.Insert;
    end;

    local procedure AssignEntityToWorkflowEvent(TableID: Integer;DynamicReqPageEntityName: Code[20])
    var
        WorkflowEvent: Record "Workflow Event";
    begin
        WorkflowEvent.SetRange("Table ID",TableID);
        if not WorkflowEvent.IsEmpty then
          WorkflowEvent.ModifyAll("Dynamic Req. Page Entity Name",DynamicReqPageEntityName,true);
    end;

    local procedure InsertVendorReqPageFields()
    var
        Vendor: Record Vendor;
    begin
        InsertReqPageField(Database::Vendor,Vendor.FieldNo("No."));
    end;
}

