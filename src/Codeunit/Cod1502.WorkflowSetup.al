#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1502 "Workflow Setup"
{

    trigger OnRun()
    begin
    end;

    var
        MsTemplateTok: label 'MS-', Locked=true;
        MsWizardWorkflowTok: label 'WZ-', Locked=true;
        PurchInvWorkflowCodeTxt: label 'PIW', Locked=true;
        PurchInvWorkflowDescriptionTxt: label 'Purchase Invoice Workflow';
        IncDocOCRWorkflowCodeTxt: label 'INCDOC-OCR', Locked=true;
        IncDocOCRWorkflowDescriptionTxt: label 'Incoming Document OCR Workflow';
        IncDocToGenJnlLineOCRWorkflowCodeTxt: label 'INCDOC-JNL-OCR', Locked=true;
        IncDocToGenJnlLineOCRWorkflowDescriptionTxt: label 'Incoming Document to General Journal Line OCR Workflow';
        IncDocExchWorkflowCodeTxt: label 'INCDOC-DOCEXCH', Locked=true;
        IncDocExchWorkflowDescriptionTxt: label 'Incoming Document Exchange Workflow';
        IncDocWorkflowCodeTxt: label 'INCDOC', Locked=true;
        IncDocWorkflowDescTxt: label 'Incoming Document Workflow';
        IncomingDocumentApprWorkflowCodeTxt: label 'INCDOCAPW', Locked=true;
        PurchInvoiceApprWorkflowCodeTxt: label 'PIAPW', Locked=true;
        PurchReturnOrderApprWorkflowCodeTxt: label 'PROAPW', Locked=true;
        PurchQuoteApprWorkflowCodeTxt: label 'PQAPW', Locked=true;
        PurchOrderApprWorkflowCodeTxt: label 'POAPW', Locked=true;
        PurchCreditMemoApprWorkflowCodeTxt: label 'PCMAPW', Locked=true;
        PurchBlanketOrderApprWorkflowCodeTxt: label 'BPOAPW', Locked=true;
        IncomingDocumentApprWorkflowDescTxt: label 'Incoming Document Approval Workflow';
        PurchInvoiceApprWorkflowDescTxt: label 'Purchase Invoice Approval Workflow';
        PurchReturnOrderApprWorkflowDescTxt: label 'Purchase Return Order Approval Workflow';
        PurchQuoteApprWorkflowDescTxt: label 'Purchase Quote Approval Workflow';
        PurchOrderApprWorkflowDescTxt: label 'Purchase Order Approval Workflow';
        PurchCreditMemoApprWorkflowDescTxt: label 'Purchase Credit Memo Approval Workflow';
        PurchBlanketOrderApprWorkflowDescTxt: label 'Blanket Purchase Order Approval Workflow';
        PendingApprovalsCondnTxt: label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Approval Entry">%1</DataItem></DataItems></ReportParameters>', Locked=true;
        PurchHeaderTypeCondnTxt: label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Purchase Header">%1</DataItem><DataItem name="Purchase Line">%2</DataItem></DataItems></ReportParameters>', Locked=true;
        SalesHeaderTypeCondnTxt: label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Sales Header">%1</DataItem><DataItem name="Sales Line">%2</DataItem></DataItems></ReportParameters>', Locked=true;
        IncomingDocumentTypeCondnTxt: label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Incoming Document">%1</DataItem><DataItem name="Incoming Document Attachment">%2</DataItem></DataItems></ReportParameters>', Locked=true;
        CustomerTypeCondnTxt: label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Customer">%1</DataItem></DataItems></ReportParameters>', Locked=true;
        VendorTypeCondnTxt: label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Vendor">%1</DataItem></DataItems></ReportParameters>', Locked=true;
        ItemTypeCondnTxt: label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Item">%1</DataItem></DataItems></ReportParameters>', Locked=true;
        GeneralJournalBatchTypeCondnTxt: label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Gen. Journal Batch">%1</DataItem></DataItems></ReportParameters>', Locked=true;
        GeneralJournalLineTypeCondnTxt: label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Gen. Journal Line">%1</DataItem></DataItems></ReportParameters>', Locked=true;
        InvalidEventCondErr: label 'No event conditions are specified.';
        OverdueWorkflowCodeTxt: label 'OVERDUE', Locked=true;
        OverdueWorkflowDescTxt: label 'Overdue Approval Requests Workflow';
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowRequestPageHandling: Codeunit "Workflow Request Page Handling";
        BlankDateFormula: DateFormula;
        SalesInvoiceApprWorkflowCodeTxt: label 'SIAPW', Locked=true;
        SalesReturnOrderApprWorkflowCodeTxt: label 'SROAPW', Locked=true;
        SalesQuoteApprWorkflowCodeTxt: label 'SQAPW', Locked=true;
        SalesOrderApprWorkflowCodeTxt: label 'SOAPW', Locked=true;
        SalesCreditMemoApprWorkflowCodeTxt: label 'SCMAPW', Locked=true;
        SalesBlanketOrderApprWorkflowCodeTxt: label 'BSOAPW', Locked=true;
        SalesInvoiceCreditLimitApprWorkflowCodeTxt: label 'SICLAPW', Locked=true;
        SalesOrderCreditLimitApprWorkflowCodeTxt: label 'SOCLAPW', Locked=true;
        SalesRetOrderCrLimitApprWorkflowCodeTxt: label 'SROCLAPW', Locked=true;
        SalesQuoteCrLimitApprWorkflowCodeTxt: label 'SQCLAPW', Locked=true;
        SalesCrMemoCrLimitApprWorkflowCodeTxt: label 'SCMCLAPW', Locked=true;
        SalesBlanketOrderCrLimitApprWorkflowCodeTxt: label 'BSOCLAPW', Locked=true;
        SalesInvoiceApprWorkflowDescTxt: label 'Sales Invoice Approval Workflow';
        SalesReturnOrderApprWorkflowDescTxt: label 'Sales Return Order Approval Workflow';
        SalesQuoteApprWorkflowDescTxt: label 'Sales Quote Approval Workflow';
        SalesOrderApprWorkflowDescTxt: label 'Sales Order Approval Workflow';
        SalesCreditMemoApprWorkflowDescTxt: label 'Sales Credit Memo Approval Workflow';
        SalesBlanketOrderApprWorkflowDescTxt: label 'Blanket Sales Order Approval Workflow';
        SalesInvoiceCreditLimitApprWorkflowDescTxt: label 'Sales Invoice Credit Limit Approval Workflow';
        SalesOrderCreditLimitApprWorkflowDescTxt: label 'Sales Order Credit Limit Approval Workflow';
        SalesRetOrderCrLimitApprWorkflowDescTxt: label 'Sales Return Order Credit Limit Approval Workflow';
        SalesQuoteCrLimitApprWorkflowDescTxt: label 'Sales Quote Credit Limit Approval Workflow';
        SalesCrMemoCrLimitApprWorkflowDescTxt: label 'Sales Credit Memo Credit Limit Approval Workflow';
        SalesBlanketOrderCrLimitApprWorkflowDescTxt: label 'Blanket Sales Order Credit Limit Approval Workflow';
        CustomerApprWorkflowCodeTxt: label 'CUSTAPW', Locked=true;
        CustomerApprWorkflowDescTxt: label 'Customer Approval Workflow';
        CustomerCredLmtChangeApprWorkflowCodeTxt: label 'CCLCAPW', Locked=true;
        CustomerCredLmtChangeApprWorkflowDescTxt: label 'Customer Credit Limit Change Approval Workflow';
        VendorApprWorkflowCodeTxt: label 'VENDAPW', Locked=true;
        VendorApprWorkflowDescTxt: label 'Vendor Approval Workflow';
        ItemApprWorkflowCodeTxt: label 'ITEMAPW', Locked=true;
        ItemApprWorkflowDescTxt: label 'Item Approval Workflow';
        ItemUnitPriceChangeApprWorkflowCodeTxt: label 'IUPCAPW', Locked=true;
        ItemUnitPriceChangeApprWorkflowDescTxt: label 'Item Unit Price Change Approval Workflow';
        GeneralJournalBatchApprWorkflowCodeTxt: label 'GJBAPW', Locked=true;
        GeneralJournalBatchApprWorkflowDescTxt: label 'General Journal Batch Approval Workflow';
        GeneralJournalLineApprWorkflowCodeTxt: label 'GJLAPW', Locked=true;
        GeneralJournalLineApprWorkflowDescTxt: label 'General Journal Line Approval Workflow';
        GeneralJournalBatchIsNotBalancedMsg: label 'The selected general journal batch is not balanced and cannot be sent for approval.', Comment='General Journal Batch refers to the name of a record.';
        ApprovalRequestCanceledMsg: label 'The approval request for the record has been canceled.';
        SendToOCRWorkflowCodeTxt: label 'INCDOC-OCR', Locked=true;
        CustCredLmtChangeSentForAppTxt: label 'The customer credit limit change was sent for approval.';
        ItemUnitPriceChangeSentForAppTxt: label 'The item unit price change was sent for approval.';
        IntegrationCategoryTxt: label 'INT', Locked=true;
        SalesMktCategoryTxt: label 'SALES', Locked=true;
        PurchPayCategoryTxt: label 'PURCH', Locked=true;
        PurchDocCategoryTxt: label 'PURCHDOC', Locked=true;
        SalesDocCategoryTxt: label 'SALESDOC', Locked=true;
        AdminCategoryTxt: label 'ADMIN', Locked=true;
        FinCategoryTxt: label 'FIN', Locked=true;
        IntegrationCategoryDescTxt: label 'Integration';
        SalesMktCategoryDescTxt: label 'Sales and Marketing';
        PurchPayCategoryDescTxt: label 'Purchases and Payables';
        PurchDocCategoryDescTxt: label 'Purchase Documents';
        SalesDocCategoryDescTxt: label 'Sales Documents';
        AdminCategoryDescTxt: label 'Administration';
        FinCategoryDescTxt: label 'Finance';


    procedure InitWorkflow()
    var
        Workflow: Record Workflow;
    begin
        WorkflowEventHandling.CreateEventsLibrary;
        WorkflowRequestPageHandling.CreateEntitiesAndFields;
        WorkflowRequestPageHandling.AssignEntitiesToWorkflowEvents;
        WorkflowResponseHandling.CreateResponsesLibrary;
        InsertWorkflowCategories;
        InsertJobQueueData;

        Workflow.SetRange(Template,true);
        if Workflow.IsEmpty then
          InsertWorkflowTemplates;
    end;

    local procedure InsertWorkflowTemplates()
    begin
        InsertApprovalsTableRelations;

        InsertIncomingDocumentWorkflowTemplate;
        InsertIncomingDocumentApprovalWorkflowTemplate;
        InsertIncomingDocumentOCRWorkflowTemplate;
        InsertIncomingDocumentToGenJnlLineOCRWorkflowTemplate;
        InsertIncomingDocumentDocExchWorkflowTemplate;

        InsertPurchaseInvoiceWorkflowTemplate;

        InsertPurchaseBlanketOrderApprovalWorkflowTemplate;
        InsertPurchaseCreditMemoApprovalWorkflowTemplate;
        InsertPurchaseInvoiceApprovalWorkflowTemplate;
        InsertPurchaseOrderApprovalWorkflowTemplate;
        InsertPurchaseQuoteApprovalWorkflowTemplate;
        InsertPurchaseReturnOrderApprovalWorkflowTemplate;

        InsertSalesBlanketOrderApprovalWorkflowTemplate;
        InsertSalesCreditMemoApprovalWorkflowTemplate;
        InsertSalesInvoiceApprovalWorkflowTemplate;
        InsertSalesOrderApprovalWorkflowTemplate;
        InsertSalesQuoteApprovalWorkflowTemplate;
        InsertSalesReturnOrderApprovalWorkflowTemplate;

        InsertSalesInvoiceCreditLimitApprovalWorkflowTemplate;
        InsertSalesOrderCreditLimitApprovalWorkflowTemplate;

        InsertOverdueApprovalsWorkflowTemplate;

        InsertCustomerApprovalWorkflowTemplate;
        InsertCustomerCreditLimitChangeApprovalWorkflowTemplate;

        InsertVendorApprovalWorkflowTemplate;

        InsertItemApprovalWorkflowTemplate;
        InsertItemUnitPriceChangeApprovalWorkflowTemplate;

        InsertGeneralJournalBatchApprovalWorkflowTemplate;
        InsertGeneralJournalLineApprovalWorkflowTemplate;
    end;


    procedure InsertWorkflowCategories()
    begin
        InsertWorkflowCategory(IntegrationCategoryTxt,IntegrationCategoryDescTxt);
        InsertWorkflowCategory(SalesMktCategoryTxt,SalesMktCategoryDescTxt);
        InsertWorkflowCategory(PurchPayCategoryTxt,PurchPayCategoryDescTxt);
        InsertWorkflowCategory(PurchDocCategoryTxt,PurchDocCategoryDescTxt);
        InsertWorkflowCategory(SalesDocCategoryTxt,SalesDocCategoryDescTxt);
        InsertWorkflowCategory(AdminCategoryTxt,AdminCategoryDescTxt);
        InsertWorkflowCategory(FinCategoryTxt,FinCategoryDescTxt);

        OnAddWorkflowCategoriesToLibrary;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
    end;

    local procedure InsertWorkflow(var Workflow: Record Workflow;WorkflowCode: Code[20];WorkflowDescription: Text[100];CategoryCode: Code[20])
    begin
        Workflow.Init;
        Workflow.Code := WorkflowCode;
        Workflow.Description := WorkflowDescription;
        Workflow.Category := CategoryCode;
        Workflow.Enabled := false;
        Workflow.Insert;
    end;

    local procedure InsertWorkflowTemplate(var Workflow: Record Workflow;WorkflowCode: Code[17];WorkflowDescription: Text[100];CategoryCode: Code[20])
    begin
        Workflow.Init;
        Workflow.Code := GetWorkflowTemplateCode(WorkflowCode);
        Workflow.Description := WorkflowDescription;
        Workflow.Category := CategoryCode;
        Workflow.Enabled := false;
        if Workflow.Insert then;
    end;


    procedure InsertApprovalsTableRelations()
    var
        IncomingDocument: Record "Incoming Document";
        ApprovalEntry: Record "Approval Entry";
        DummyGenJournalLine: Record "Gen. Journal Line";
    begin
        InsertTableRelation(Database::"Purchase Header",0,
          Database::"Approval Entry",ApprovalEntry.FieldNo("Record ID to Approve"));

        InsertTableRelation(Database::"Sales Header",0,
          Database::"Approval Entry",ApprovalEntry.FieldNo("Record ID to Approve"));

        InsertTableRelation(Database::Customer,0,
          Database::"Approval Entry",ApprovalEntry.FieldNo("Record ID to Approve"));
        InsertTableRelation(Database::Vendor,0,
          Database::"Approval Entry",ApprovalEntry.FieldNo("Record ID to Approve"));
        InsertTableRelation(Database::Item,0,
          Database::"Approval Entry",ApprovalEntry.FieldNo("Record ID to Approve"));
        InsertTableRelation(Database::"Gen. Journal Line",0,
          Database::"Approval Entry",ApprovalEntry.FieldNo("Record ID to Approve"));
        InsertTableRelation(Database::"Gen. Journal Batch",0,
          Database::"Approval Entry",ApprovalEntry.FieldNo("Record ID to Approve"));

        InsertTableRelation(
          Database::"Incoming Document",IncomingDocument.FieldNo("Entry No."),
          Database::"Approval Entry",ApprovalEntry.FieldNo("Document No."));
        InsertTableRelation(
          Database::"Approval Entry",ApprovalEntry.FieldNo("Document No."),
          Database::"Incoming Document",IncomingDocument.FieldNo("Entry No."));

        InsertTableRelation(
          Database::"Incoming Document",IncomingDocument.FieldNo("Entry No."),Database::"Gen. Journal Line",
          DummyGenJournalLine.FieldNo("Incoming Document Entry No."));
    end;

    local procedure InsertIncomingDocumentWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,IncDocWorkflowCodeTxt,IncDocWorkflowDescTxt,IntegrationCategoryTxt);
        InsertIncomingDocumentWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertIncomingDocumentWorkflowDetails(var Workflow: Record Workflow)
    var
        IncomingDocument: Record "Incoming Document";
        PurchaseHeader: Record "Purchase Header";
        OnIncomingDocumentCreatedEventID: Integer;
    begin
        InsertTableRelation(Database::"Incoming Document",IncomingDocument.FieldNo("Entry No."),
          Database::"Purchase Header",PurchaseHeader.FieldNo("Incoming Document Entry No."));
        InsertTableRelation(Database::"Purchase Header",PurchaseHeader.FieldNo("Incoming Document Entry No."),
          Database::"Incoming Document",IncomingDocument.FieldNo("Entry No."));

        OnIncomingDocumentCreatedEventID :=
          InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterInsertIncomingDocumentCode);
        InsertResponseStep(Workflow,WorkflowResponseHandling.CreateNotificationEntryCode,OnIncomingDocumentCreatedEventID);
    end;

    local procedure InsertIncomingDocumentOCRWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(
          Workflow,IncDocOCRWorkflowCodeTxt,IncDocOCRWorkflowDescriptionTxt,IntegrationCategoryTxt);
        InsertIncomingDocumentOCRWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertIncomingDocumentOCRWorkflowDetails(var Workflow: Record Workflow)
    var
        IncomingDocument: Record "Incoming Document";
        OCRSuccessEventID: Integer;
        CreateDocResponseID: Integer;
        NotifyResponseID: Integer;
        DocSuccessEventID: Integer;
        DocErrorEventID: Integer;
    begin
        OCRSuccessEventID :=
          InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterReceiveFromOCRIncomingDocCode);
        InsertEventArgument(
          OCRSuccessEventID,BuildIncomingDocumentOCRTypeConditions(IncomingDocument."ocr status"::Success));
        CreateDocResponseID :=
          InsertResponseStep(Workflow,WorkflowResponseHandling.GetCreateDocFromIncomingDocCode,OCRSuccessEventID);

        DocSuccessEventID :=
          InsertEventStep(
            Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateDocFromIncomingDocSuccessCode,CreateDocResponseID);
        InsertEventArgument(DocSuccessEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::Created));
        InsertResponseStep(Workflow,WorkflowResponseHandling.DoNothingCode,DocSuccessEventID);

        DocErrorEventID :=
          InsertEventStep(
            Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateDocFromIncomingDocFailCode,CreateDocResponseID);
        InsertEventArgument(DocErrorEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::Failed));
        NotifyResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreateNotificationEntryCode,DocErrorEventID);

        InsertNotificationArgument(NotifyResponseID,'',Page::"Incoming Document",'');
    end;

    local procedure InsertIncomingDocumentToGenJnlLineOCRWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(
          Workflow,IncDocToGenJnlLineOCRWorkflowCodeTxt,IncDocToGenJnlLineOCRWorkflowDescriptionTxt,IntegrationCategoryTxt);
        InsertIncomingDocumentToGenJnlLineOCRWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertIncomingDocumentToGenJnlLineOCRWorkflowDetails(var Workflow: Record Workflow)
    var
        IncomingDocument: Record "Incoming Document";
        OCRSuccessForGenJnlLineEventID: Integer;
        CreateDocForGenJnlLineResponseID: Integer;
        GenJnlLineSuccessEventID: Integer;
        GenJnlLineFailEventID: Integer;
        CreateGenJnlLineFailResponseID: Integer;
    begin
        OCRSuccessForGenJnlLineEventID :=
          InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterReceiveFromOCRIncomingDocCode);
        InsertEventArgument(
          OCRSuccessForGenJnlLineEventID,BuildIncomingDocumentOCRTypeConditions(IncomingDocument."ocr status"::Success));
        CreateDocForGenJnlLineResponseID :=
          InsertResponseStep(Workflow,WorkflowResponseHandling.GetCreateJournalFromIncomingDocCode,OCRSuccessForGenJnlLineEventID);

        GenJnlLineSuccessEventID :=
          InsertEventStep(
            Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocSuccessCode,
            CreateDocForGenJnlLineResponseID);
        InsertResponseStep(Workflow,WorkflowResponseHandling.DoNothingCode,GenJnlLineSuccessEventID);

        GenJnlLineFailEventID :=
          InsertEventStep(
            Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocFailCode,CreateDocForGenJnlLineResponseID);
        CreateGenJnlLineFailResponseID :=
          InsertResponseStep(Workflow,WorkflowResponseHandling.CreateNotificationEntryCode,GenJnlLineFailEventID);

        InsertNotificationArgument(CreateGenJnlLineFailResponseID,'',Page::"Incoming Document",'');
    end;

    local procedure InsertIncomingDocumentDocExchWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,IncDocExchWorkflowCodeTxt,IncDocExchWorkflowDescriptionTxt,IntegrationCategoryTxt);
        InsertIncomingDocumentDocExchWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertIncomingDocumentDocExchWorkflowDetails(var Workflow: Record Workflow)
    var
        IncomingDocument: Record "Incoming Document";
        IncDocCreatedEventID: Integer;
        DocReleasedEventID: Integer;
        DocSuccessEventID: Integer;
        DocErrorEventID: Integer;
        ReleaseDocResponseID: Integer;
        CreateDocResponseID: Integer;
        NotifyResponseID: Integer;
    begin
        IncDocCreatedEventID :=
          InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterReceiveFromDocExchIncomingDocCode);
        InsertEventArgument(IncDocCreatedEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::New));
        ReleaseDocResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ReleaseDocumentCode,IncDocCreatedEventID);

        DocReleasedEventID :=
          InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterReleaseIncomingDocCode,ReleaseDocResponseID);
        InsertEventArgument(DocReleasedEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::Released));
        CreateDocResponseID :=
          InsertResponseStep(Workflow,WorkflowResponseHandling.GetCreateDocFromIncomingDocCode,DocReleasedEventID);

        DocSuccessEventID :=
          InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateDocFromIncomingDocSuccessCode,CreateDocResponseID);
        InsertEventArgument(DocSuccessEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::Created));
        InsertResponseStep(Workflow,WorkflowResponseHandling.DoNothingCode,DocSuccessEventID);

        DocErrorEventID :=
          InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateDocFromIncomingDocFailCode,CreateDocResponseID);
        InsertEventArgument(DocErrorEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::Failed));
        NotifyResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreateNotificationEntryCode,DocErrorEventID);

        InsertNotificationArgument(NotifyResponseID,'',Page::"Incoming Document",'');
    end;

    local procedure InsertPurchaseInvoiceWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,PurchInvWorkflowCodeTxt,PurchInvWorkflowDescriptionTxt,PurchDocCategoryTxt);
        InsertPurchaseInvoiceWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertPurchaseInvoiceWorkflowDetails(var Workflow: Record Workflow)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        GenJournalLine: Record "Gen. Journal Line";
        DocReleasedEventID: Integer;
        PostedEventID: Integer;
        JournalLineCreatedEventID: Integer;
        PostDocAsyncResponseID: Integer;
        CreatePmtLineResponseID: Integer;
        NotifyResponseID: Integer;
    begin
        InsertTableRelation(Database::"Purchase Header",PurchaseHeader.FieldNo("No."),
          Database::"Purch. Inv. Header",PurchInvHeader.FieldNo("Pre-Assigned No."));
        InsertTableRelation(Database::"Purch. Inv. Header",PurchaseHeader.FieldNo("No."),
          Database::"Gen. Journal Line",GenJournalLine.FieldNo("Applies-to Doc. No."));

        DocReleasedEventID := InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterReleasePurchaseDocCode);
        InsertEventArgument(DocReleasedEventID,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::Invoice,PurchaseHeader.Status::Released));

        PostDocAsyncResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.PostDocumentAsyncCode,DocReleasedEventID);

        PostedEventID :=
          InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterPostPurchaseDocCode,PostDocAsyncResponseID);
        CreatePmtLineResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreatePmtLineForPostedPurchaseDocAsyncCode,
            PostedEventID);
        InsertPmtLineCreationArgument(CreatePmtLineResponseID,'','');

        JournalLineCreatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterInsertGeneralJournalLineCode,
            CreatePmtLineResponseID);

        GenJournalLine.SetRange("Document Type",GenJournalLine."document type"::Payment);
        InsertEventArgument(JournalLineCreatedEventID,BuildGeneralJournalLineTypeConditions(GenJournalLine));

        NotifyResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreateNotificationEntryCode,JournalLineCreatedEventID);
        InsertNotificationArgument(NotifyResponseID,'',Page::"Payment Journal",'');
    end;


    procedure InsertIncomingDocumentApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,IncomingDocumentApprWorkflowCodeTxt,IncomingDocumentApprWorkflowDescTxt,IntegrationCategoryTxt);
        InsertIncomingDocumentApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertIncomingDocumentApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        IncomingDocument: Record "Incoming Document";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Workflow User Group",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(
          Workflow,
          BuildIncomingDocumentTypeConditions(IncomingDocument.Status::New),
          WorkflowEventHandling.RunWorkflowOnSendIncomingDocForApprovalCode,
          BuildIncomingDocumentTypeConditions(IncomingDocument.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelIncomingDocApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertPurchaseInvoiceApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,PurchInvoiceApprWorkflowCodeTxt,PurchInvoiceApprWorkflowDescTxt,PurchDocCategoryTxt);
        InsertPurchaseInvoiceApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertPurchaseInvoiceApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        PurchaseHeader: Record "Purchase Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Salesperson/Purchaser",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::Invoice,PurchaseHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::Invoice,PurchaseHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertPurchaseBlanketOrderApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,PurchBlanketOrderApprWorkflowCodeTxt,PurchBlanketOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
        InsertPurchaseBlanketOrderApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertPurchaseBlanketOrderApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        PurchaseHeader: Record "Purchase Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Workflow User Group",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::"Blanket Order",PurchaseHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::"Blanket Order",PurchaseHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertPurchaseCreditMemoApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,PurchCreditMemoApprWorkflowCodeTxt,PurchCreditMemoApprWorkflowDescTxt,PurchDocCategoryTxt);
        InsertPurchaseCreditMemoApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertPurchaseCreditMemoApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        PurchaseHeader: Record "Purchase Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Salesperson/Purchaser",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::"Credit Memo",PurchaseHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::"Credit Memo",PurchaseHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertPurchaseOrderApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,PurchOrderApprWorkflowCodeTxt,PurchOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
        InsertPurchaseOrderApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertPurchaseOrderApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        InsertTableRelation(Database::"Purchase Header",PurchaseHeader.FieldNo("Document Type"),
          Database::"Purchase Line",PurchaseLine.FieldNo("Document Type"));
        InsertTableRelation(Database::"Purchase Header",PurchaseHeader.FieldNo("No."),
          Database::"Purchase Line",PurchaseLine.FieldNo("Document No."));

        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::Approver,WorkflowStepArgument."approver limit type"::"Approver Chain",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::Order,PurchaseHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::Order,PurchaseHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertPurchaseQuoteApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,PurchQuoteApprWorkflowCodeTxt,PurchQuoteApprWorkflowDescTxt,PurchDocCategoryTxt);
        InsertPurchaseQuoteApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertPurchaseQuoteApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        PurchaseHeader: Record "Purchase Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::Approver,WorkflowStepArgument."approver limit type"::"Approver Chain",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::Quote,PurchaseHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::Quote,PurchaseHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertPurchaseReturnOrderApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,PurchReturnOrderApprWorkflowCodeTxt,PurchReturnOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
        InsertPurchaseReturnOrderApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertPurchaseReturnOrderApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        PurchaseHeader: Record "Purchase Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Salesperson/Purchaser",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::"Return Order",PurchaseHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
          BuildPurchHeaderTypeConditions(PurchaseHeader."document type"::"Return Order",PurchaseHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertSalesInvoiceApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,SalesInvoiceApprWorkflowCodeTxt,SalesInvoiceApprWorkflowDescTxt,SalesDocCategoryTxt);
        InsertSalesInvoiceApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertSalesInvoiceApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        SalesHeader: Record "Sales Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Salesperson/Purchaser",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::Invoice,SalesHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::Invoice,SalesHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertSalesBlanketOrderApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,SalesBlanketOrderApprWorkflowCodeTxt,SalesBlanketOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
        InsertSalesBlanketOrderApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertSalesBlanketOrderApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        SalesHeader: Record "Sales Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Workflow User Group",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::"Blanket Order",SalesHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::"Blanket Order",SalesHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertSalesCreditMemoApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,SalesCreditMemoApprWorkflowCodeTxt,SalesCreditMemoApprWorkflowDescTxt,SalesDocCategoryTxt);
        InsertSalesCreditMemoApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertSalesCreditMemoApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        SalesHeader: Record "Sales Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Salesperson/Purchaser",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::"Credit Memo",SalesHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::"Credit Memo",SalesHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertSalesOrderApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,SalesOrderApprWorkflowCodeTxt,SalesOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
        InsertSalesOrderApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertSalesOrderApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        InsertTableRelation(Database::"Sales Header",SalesHeader.FieldNo("Document Type"),
          Database::"Sales Line",SalesLine.FieldNo("Document Type"));
        InsertTableRelation(Database::"Sales Header",SalesHeader.FieldNo("No."),
          Database::"Sales Line",SalesLine.FieldNo("Document No."));

        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Salesperson/Purchaser",
          WorkflowStepArgument."approver limit type"::"Approver Chain",0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::Order,SalesHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::Order,SalesHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertSalesQuoteApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,SalesQuoteApprWorkflowCodeTxt,SalesQuoteApprWorkflowDescTxt,SalesDocCategoryTxt);
        InsertSalesQuoteApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertSalesQuoteApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        SalesHeader: Record "Sales Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Salesperson/Purchaser",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::Quote,SalesHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::Quote,SalesHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertSalesReturnOrderApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,SalesReturnOrderApprWorkflowCodeTxt,SalesReturnOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
        InsertSalesReturnOrderApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertSalesReturnOrderApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        SalesHeader: Record "Sales Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Salesperson/Purchaser",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::"Return Order",SalesHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::"Return Order",SalesHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertSalesInvoiceCreditLimitApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,SalesInvoiceCreditLimitApprWorkflowCodeTxt,
          SalesInvoiceCreditLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
        InsertSalesInvoiceCreditLimitApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertSalesInvoiceCreditLimitApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        SalesHeader: Record "Sales Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Salesperson/Purchaser",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertSalesDocWithCreditLimitApprovalWorkflowSteps(Workflow,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::Invoice,SalesHeader.Status::Open),
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::Invoice,SalesHeader.Status::"Pending Approval"),
          WorkflowStepArgument,true);
    end;

    local procedure InsertSalesOrderCreditLimitApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,SalesOrderCreditLimitApprWorkflowCodeTxt,
          SalesOrderCreditLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
        InsertSalesOrderCreditLimitApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertSalesOrderCreditLimitApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        SalesHeader: Record "Sales Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Salesperson/Purchaser",
          WorkflowStepArgument."approver limit type"::"Approver Chain",0,'',BlankDateFormula,true);

        InsertSalesDocWithCreditLimitApprovalWorkflowSteps(Workflow,
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::Order,SalesHeader.Status::Open),
          BuildSalesHeaderTypeConditions(SalesHeader."document type"::Order,SalesHeader.Status::"Pending Approval"),
          WorkflowStepArgument,true);
    end;

    local procedure InsertSalesDocWithCreditLimitApprovalWorkflowSteps(Workflow: Record Workflow;DocSentForApprovalConditionString: Text;DocCanceledConditionString: Text;WorkflowStepArgument: Record "Workflow Step Argument";ShowConfirmationMessage: Boolean)
    var
        SentForApprovalEventID: Integer;
        CheckCustomerCreditLimitResponseID: Integer;
        CustomerCreditLimitExceededEventID: Integer;
        CustomerCreditLimitNotExceededEventID: Integer;
        SetStatusToPendingApprovalResponseID: Integer;
        CreateApprovalRequestResponseID: Integer;
        SendApprovalRequestResponseID: Integer;
        OnAllRequestsApprovedEventID: Integer;
        OnRequestApprovedEventID: Integer;
        SendApprovalRequestResponseID2: Integer;
        OnRequestRejectedEventID: Integer;
        RejectAllApprovalsResponseID: Integer;
        OnRequestCanceledEventID: Integer;
        CancelAllApprovalsResponseID: Integer;
        OnRequestDelegatedEventID: Integer;
        SentApprovalRequestResponseID3: Integer;
        SetStatusToPendingApprovalResponseID2: Integer;
        CreateAndApproveApprovalRequestResponseID: Integer;
        OpenDocumentResponseID: Integer;
        ShowMessageResponseID: Integer;
    begin
        SentForApprovalEventID := InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode);
        InsertEventArgument(SentForApprovalEventID,DocSentForApprovalConditionString);

        CheckCustomerCreditLimitResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CheckCustomerCreditLimitCode,
            SentForApprovalEventID);

        CustomerCreditLimitExceededEventID := InsertEventStep(Workflow,
            WorkflowEventHandling.RunWorkflowOnCustomerCreditLimitExceededCode,CheckCustomerCreditLimitResponseID);

        SetStatusToPendingApprovalResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.SetStatusToPendingApprovalCode,
            CustomerCreditLimitExceededEventID);
        CreateApprovalRequestResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreateApprovalRequestsCode,
            SetStatusToPendingApprovalResponseID);
        InsertApprovalArgument(CreateApprovalRequestResponseID,
          WorkflowStepArgument."Approver Type",WorkflowStepArgument."Approver Limit Type",
          WorkflowStepArgument."Workflow User Group Code",WorkflowStepArgument."Approver User ID",
          WorkflowStepArgument."Due Date Formula",ShowConfirmationMessage);
        SendApprovalRequestResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            CreateApprovalRequestResponseID);

        InsertNotificationArgument(SendApprovalRequestResponseID,'',0,'');

        OnAllRequestsApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        InsertEventArgument(OnAllRequestsApprovedEventID,BuildNoPendingApprovalsConditions);
        InsertResponseStep(Workflow,WorkflowResponseHandling.ReleaseDocumentCode,OnAllRequestsApprovedEventID);

        OnRequestApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        InsertEventArgument(OnRequestApprovedEventID,BuildPendingApprovalsConditions);
        SendApprovalRequestResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestApprovedEventID);

        SetNextStep(Workflow,SendApprovalRequestResponseID2,SendApprovalRequestResponseID);

        OnRequestRejectedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
            SendApprovalRequestResponseID);
        RejectAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RejectAllApprovalRequestsCode,
            OnRequestRejectedEventID);
        InsertNotificationArgument(RejectAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');
        InsertResponseStep(Workflow,WorkflowResponseHandling.OpenDocumentCode,RejectAllApprovalsResponseID);

        OnRequestCanceledEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
            SendApprovalRequestResponseID);
        InsertEventArgument(OnRequestCanceledEventID,DocCanceledConditionString);
        CancelAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CancelAllApprovalRequestsCode,
            OnRequestCanceledEventID);
        InsertNotificationArgument(CancelAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');
        OpenDocumentResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.OpenDocumentCode,CancelAllApprovalsResponseID);
        ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,OpenDocumentResponseID);
        InsertMessageArgument(ShowMessageResponseID,ApprovalRequestCanceledMsg);

        OnRequestDelegatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
            SendApprovalRequestResponseID);
        SentApprovalRequestResponseID3 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestDelegatedEventID);

        SetNextStep(Workflow,SentApprovalRequestResponseID3,SendApprovalRequestResponseID);

        CustomerCreditLimitNotExceededEventID := InsertEventStep(Workflow,
            WorkflowEventHandling.RunWorkflowOnCustomerCreditLimitNotExceededCode,CheckCustomerCreditLimitResponseID);

        SetStatusToPendingApprovalResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SetStatusToPendingApprovalCode,
            CustomerCreditLimitNotExceededEventID);

        CreateAndApproveApprovalRequestResponseID := InsertResponseStep(Workflow,
            WorkflowResponseHandling.CreateAndApproveApprovalRequestAutomaticallyCode,SetStatusToPendingApprovalResponseID2);
        InsertResponseStep(Workflow,WorkflowResponseHandling.ReleaseDocumentCode,
          CreateAndApproveApprovalRequestResponseID);
    end;

    local procedure InsertOverdueApprovalsWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,OverdueWorkflowCodeTxt,OverdueWorkflowDescTxt,AdminCategoryTxt);
        InsertOverdueApprovalsWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;


    procedure InsertOverdueApprovalsWorkflow(): Code[20]
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflow(Workflow,GetWorkflowCode(OverdueWorkflowCodeTxt),OverdueWorkflowDescTxt,AdminCategoryTxt);
        InsertOverdueApprovalsWorkflowDetails(Workflow);
        exit(Workflow.Code);
    end;

    local procedure InsertOverdueApprovalsWorkflowDetails(var Workflow: Record Workflow)
    var
        OnSendOverdueNotificationsEventID: Integer;
    begin
        OnSendOverdueNotificationsEventID :=
          InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnSendOverdueNotificationsCode);
        InsertResponseStep(Workflow,WorkflowResponseHandling.CreateOverdueNotificationCode,OnSendOverdueNotificationsEventID);
    end;

    local procedure InsertCustomerApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,CustomerApprWorkflowCodeTxt,CustomerApprWorkflowDescTxt,SalesMktCategoryTxt);
        InsertCustomerApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;


    procedure InsertCustomerApprovalWorkflow()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflow(Workflow,GetWorkflowCode(CustomerApprWorkflowCodeTxt),CustomerApprWorkflowDescTxt,SalesMktCategoryTxt);
        InsertCustomerApprovalWorkflowDetails(Workflow);
    end;

    local procedure InsertCustomerApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::Approver,WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertRecApprovalWorkflowSteps(Workflow,BuildCustomerTypeConditions,
          WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelCustomerApprovalRequestCode,
          WorkflowStepArgument,
          true,true);
    end;

    local procedure InsertVendorApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,VendorApprWorkflowCodeTxt,VendorApprWorkflowDescTxt,PurchPayCategoryTxt);
        InsertVendorApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;


    procedure InsertVendorApprovalWorkflow()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflow(Workflow,GetWorkflowCode(VendorApprWorkflowCodeTxt),VendorApprWorkflowDescTxt,PurchPayCategoryTxt);
        InsertVendorApprovalWorkflowDetails(Workflow);
    end;

    local procedure InsertVendorApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::Approver,WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertRecApprovalWorkflowSteps(Workflow,BuildVendorTypeConditions,
          WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelVendorApprovalRequestCode,
          WorkflowStepArgument,
          true,true);
    end;

    local procedure InsertItemApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,ItemApprWorkflowCodeTxt,ItemApprWorkflowDescTxt,SalesMktCategoryTxt);
        InsertItemApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;


    procedure InsertItemApprovalWorkflow()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflow(Workflow,GetWorkflowCode(ItemApprWorkflowCodeTxt),ItemApprWorkflowDescTxt,SalesMktCategoryTxt);
        InsertItemApprovalWorkflowDetails(Workflow);
    end;

    local procedure InsertItemApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::Approver,WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertRecApprovalWorkflowSteps(Workflow,BuildItemTypeConditions,
          WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelItemApprovalRequestCode,
          WorkflowStepArgument,
          true,true);
    end;

    local procedure InsertCustomerCreditLimitChangeApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,CustomerCredLmtChangeApprWorkflowCodeTxt,
          CustomerCredLmtChangeApprWorkflowDescTxt,SalesMktCategoryTxt);
        InsertCustomerCreditLimitChangeApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertCustomerCreditLimitChangeApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        Customer: Record Customer;
        WorkflowRule: Record "Workflow Rule";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Workflow User Group",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,false);

        InsertRecChangedApprovalWorkflowSteps(Workflow,WorkflowRule.Operator::Increased,
          WorkflowEventHandling.RunWorkflowOnCustomerChangedCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowStepArgument,Database::Customer,Customer.FieldNo("Credit Limit (LCY)"),
          CustCredLmtChangeSentForAppTxt);
    end;

    local procedure InsertItemUnitPriceChangeApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,ItemUnitPriceChangeApprWorkflowCodeTxt,
          ItemUnitPriceChangeApprWorkflowDescTxt,SalesMktCategoryTxt);
        InsertItemUnitPriceChangeApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertItemUnitPriceChangeApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        Item: Record Item;
        WorkflowRule: Record "Workflow Rule";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::"Workflow User Group",WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,false);

        InsertRecChangedApprovalWorkflowSteps(Workflow,WorkflowRule.Operator::Increased,
          WorkflowEventHandling.RunWorkflowOnItemChangedCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowStepArgument,Database::Item,Item.FieldNo("Unit Price"),
          ItemUnitPriceChangeSentForAppTxt);
    end;

    local procedure InsertGeneralJournalBatchApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,GeneralJournalBatchApprWorkflowCodeTxt,
          GeneralJournalBatchApprWorkflowDescTxt,FinCategoryTxt);
        InsertGeneralJournalBatchApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertGeneralJournalBatchApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::Approver,WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,true);

        InsertGenJnlBatchApprovalWorkflowSteps(Workflow,BuildGeneralJournalBatchTypeConditions,
          WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalBatchApprovalRequestCode,
          WorkflowStepArgument,true);
    end;

    local procedure InsertGeneralJournalLineApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow,GeneralJournalLineApprWorkflowCodeTxt,
          GeneralJournalLineApprWorkflowDescTxt,FinCategoryTxt);
        InsertGeneralJournalLineApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertGeneralJournalLineApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        GenJournalLine: Record "Gen. Journal Line";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."approver type"::Approver,WorkflowStepArgument."approver limit type"::"Direct Approver",
          0,'',BlankDateFormula,false);

        GenJournalLine.Init;
        InsertRecApprovalWorkflowSteps(Workflow,BuildGeneralJournalLineTypeConditions(GenJournalLine),
          WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode,
          WorkflowStepArgument,
          false,false);
    end;


    procedure IncomingDocumentWorkflowCode(): Code[17]
    begin
        exit(IncDocWorkflowCodeTxt);
    end;


    procedure IncomingDocumentApprovalWorkflowCode(): Code[17]
    begin
        exit(IncomingDocumentApprWorkflowCodeTxt);
    end;


    procedure IncomingDocumentOCRWorkflowCode(): Code[17]
    begin
        exit(IncDocOCRWorkflowCodeTxt);
    end;


    procedure IncomingDocumentToGenJnlLineOCRWorkflowCode(): Code[17]
    begin
        exit(IncDocToGenJnlLineOCRWorkflowCodeTxt);
    end;


    procedure PurchaseInvoiceWorkflowCode(): Code[17]
    begin
        exit(PurchInvWorkflowCodeTxt);
    end;


    procedure PurchaseInvoiceApprovalWorkflowCode(): Code[17]
    begin
        exit(PurchInvoiceApprWorkflowCodeTxt);
    end;


    procedure PurchaseBlanketOrderApprovalWorkflowCode(): Code[17]
    begin
        exit(PurchBlanketOrderApprWorkflowCodeTxt);
    end;


    procedure PurchaseCreditMemoApprovalWorkflowCode(): Code[17]
    begin
        exit(PurchCreditMemoApprWorkflowCodeTxt);
    end;


    procedure PurchaseQuoteApprovalWorkflowCode(): Code[17]
    begin
        exit(PurchQuoteApprWorkflowCodeTxt);
    end;


    procedure PurchaseOrderApprovalWorkflowCode(): Code[17]
    begin
        exit(PurchOrderApprWorkflowCodeTxt);
    end;


    procedure PurchaseReturnOrderApprovalWorkflowCode(): Code[17]
    begin
        exit(PurchReturnOrderApprWorkflowCodeTxt);
    end;


    procedure SalesInvoiceApprovalWorkflowCode(): Code[17]
    begin
        exit(SalesInvoiceApprWorkflowCodeTxt);
    end;


    procedure SalesBlanketOrderApprovalWorkflowCode(): Code[17]
    begin
        exit(SalesBlanketOrderApprWorkflowCodeTxt);
    end;


    procedure SalesCreditMemoApprovalWorkflowCode(): Code[17]
    begin
        exit(SalesCreditMemoApprWorkflowCodeTxt);
    end;


    procedure SalesQuoteApprovalWorkflowCode(): Code[17]
    begin
        exit(SalesQuoteApprWorkflowCodeTxt);
    end;


    procedure SalesOrderApprovalWorkflowCode(): Code[17]
    begin
        exit(SalesOrderApprWorkflowCodeTxt);
    end;


    procedure SalesReturnOrderApprovalWorkflowCode(): Code[17]
    begin
        exit(SalesReturnOrderApprWorkflowCodeTxt);
    end;


    procedure OverdueNotificationsWorkflowCode(): Code[17]
    begin
        exit(OverdueWorkflowCodeTxt);
    end;


    procedure SalesInvoiceCreditLimitApprovalWorkflowCode(): Code[17]
    begin
        exit(SalesInvoiceCreditLimitApprWorkflowCodeTxt);
    end;


    procedure SalesOrderCreditLimitApprovalWorkflowCode(): Code[17]
    begin
        exit(SalesOrderCreditLimitApprWorkflowCodeTxt);
    end;


    procedure CustomerWorkflowCode(): Code[17]
    begin
        exit(CustomerApprWorkflowCodeTxt);
    end;


    procedure CustomerCreditLimitChangeApprovalWorkflowCode(): Code[17]
    begin
        exit(CustomerCredLmtChangeApprWorkflowCodeTxt);
    end;


    procedure VendorWorkflowCode(): Code[17]
    begin
        exit(VendorApprWorkflowCodeTxt);
    end;


    procedure ItemWorkflowCode(): Code[17]
    begin
        exit(ItemApprWorkflowCodeTxt);
    end;


    procedure ItemUnitPriceChangeApprovalWorkflowCode(): Code[17]
    begin
        exit(ItemUnitPriceChangeApprWorkflowCodeTxt);
    end;


    procedure GeneralJournalBatchApprovalWorkflowCode(): Code[17]
    begin
        exit(GeneralJournalBatchApprWorkflowCodeTxt);
    end;


    procedure GeneralJournalLineApprovalWorkflowCode(): Code[17]
    begin
        exit(GeneralJournalLineApprWorkflowCodeTxt);
    end;


    procedure SendToOCRWorkflowCode(): Code[17]
    begin
        exit(SendToOCRWorkflowCodeTxt);
    end;


    procedure InsertDocApprovalWorkflowSteps(Workflow: Record Workflow;DocSendForApprovalConditionString: Text;DocSendForApprovalEventCode: Code[128];DocCanceledConditionString: Text;DocCanceledEventCode: Code[128];WorkflowStepArgument: Record "Workflow Step Argument";ShowConfirmationMessage: Boolean)
    var
        SentForApprovalEventID: Integer;
        SetStatusToPendingApprovalResponseID: Integer;
        CreateApprovalRequestResponseID: Integer;
        SendApprovalRequestResponseID: Integer;
        OnAllRequestsApprovedEventID: Integer;
        OnRequestApprovedEventID: Integer;
        SendApprovalRequestResponseID2: Integer;
        OnRequestRejectedEventID: Integer;
        RejectAllApprovalsResponseID: Integer;
        OnRequestCanceledEventID: Integer;
        CancelAllApprovalsResponseID: Integer;
        OnRequestDelegatedEventID: Integer;
        SentApprovalRequestResponseID3: Integer;
        RestrictRecordUsageResponseID: Integer;
        AllowRecordUsageResponseID: Integer;
        OpenDocumentResponceID: Integer;
        ShowMessageResponseID: Integer;
    begin
        SentForApprovalEventID := InsertEntryPointEventStep(Workflow,DocSendForApprovalEventCode);
        InsertEventArgument(SentForApprovalEventID,DocSendForApprovalConditionString);

        RestrictRecordUsageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RestrictRecordUsageCode,
            SentForApprovalEventID);
        SetStatusToPendingApprovalResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.SetStatusToPendingApprovalCode,
            RestrictRecordUsageResponseID);
        CreateApprovalRequestResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreateApprovalRequestsCode,
            SetStatusToPendingApprovalResponseID);
        InsertApprovalArgument(CreateApprovalRequestResponseID,
          WorkflowStepArgument."Approver Type",WorkflowStepArgument."Approver Limit Type",
          WorkflowStepArgument."Workflow User Group Code",WorkflowStepArgument."Approver User ID",
          WorkflowStepArgument."Due Date Formula",ShowConfirmationMessage);
        SendApprovalRequestResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            CreateApprovalRequestResponseID);
        InsertNotificationArgument(SendApprovalRequestResponseID,'',0,'');

        OnAllRequestsApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        InsertEventArgument(OnAllRequestsApprovedEventID,BuildNoPendingApprovalsConditions);
        AllowRecordUsageResponseID :=
          InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,OnAllRequestsApprovedEventID);
        InsertResponseStep(Workflow,WorkflowResponseHandling.ReleaseDocumentCode,AllowRecordUsageResponseID);

        OnRequestApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        InsertEventArgument(OnRequestApprovedEventID,BuildPendingApprovalsConditions);
        SendApprovalRequestResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestApprovedEventID);

        SetNextStep(Workflow,SendApprovalRequestResponseID2,SendApprovalRequestResponseID);

        OnRequestRejectedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
            SendApprovalRequestResponseID);
        RejectAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RejectAllApprovalRequestsCode,
            OnRequestRejectedEventID);
        InsertNotificationArgument(RejectAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');
        InsertResponseStep(Workflow,WorkflowResponseHandling.OpenDocumentCode,RejectAllApprovalsResponseID);

        OnRequestCanceledEventID := InsertEventStep(Workflow,DocCanceledEventCode,
            SendApprovalRequestResponseID);
        InsertEventArgument(OnRequestCanceledEventID,DocCanceledConditionString);
        CancelAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CancelAllApprovalRequestsCode,
            OnRequestCanceledEventID);
        InsertNotificationArgument(CancelAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');
        AllowRecordUsageResponseID :=
          InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,CancelAllApprovalsResponseID);
        OpenDocumentResponceID := InsertResponseStep(Workflow,WorkflowResponseHandling.OpenDocumentCode,AllowRecordUsageResponseID);
        ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,OpenDocumentResponceID);
        InsertMessageArgument(ShowMessageResponseID,ApprovalRequestCanceledMsg);

        OnRequestDelegatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
            SendApprovalRequestResponseID);
        SentApprovalRequestResponseID3 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestDelegatedEventID);

        SetNextStep(Workflow,SentApprovalRequestResponseID3,SendApprovalRequestResponseID);
    end;


    procedure InsertRecApprovalWorkflowSteps(Workflow: Record Workflow;ConditionString: Text;RecSendForApprovalEventCode: Code[128];RecCreateApprovalRequestsCode: Code[128];RecSendApprovalRequestForApprovalCode: Code[128];RecCanceledEventCode: Code[128];WorkflowStepArgument: Record "Workflow Step Argument";ShowConfirmationMessage: Boolean;RemoveRestrictionOnCancel: Boolean)
    var
        SentForApprovalEventID: Integer;
        CreateApprovalRequestResponseID: Integer;
        SendApprovalRequestResponseID: Integer;
        OnAllRequestsApprovedEventID: Integer;
        OnRequestApprovedEventID: Integer;
        SendApprovalRequestResponseID2: Integer;
        OnRequestRejectedEventID: Integer;
        RejectAllApprovalsResponseID: Integer;
        OnRequestCanceledEventID: Integer;
        CancelAllApprovalsResponseID: Integer;
        OnRequestDelegatedEventID: Integer;
        SentApprovalRequestResponseID3: Integer;
        RestrictUsageResponseID: Integer;
        AllowRecordUsageResponseID: Integer;
        ShowMessageResponseID: Integer;
        TempResponseResponseID: Integer;
    begin
        SentForApprovalEventID := InsertEntryPointEventStep(Workflow,RecSendForApprovalEventCode);
        InsertEventArgument(SentForApprovalEventID,ConditionString);

        RestrictUsageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RestrictRecordUsageCode,
            SentForApprovalEventID);
        CreateApprovalRequestResponseID := InsertResponseStep(Workflow,RecCreateApprovalRequestsCode,
            RestrictUsageResponseID);
        InsertApprovalArgument(CreateApprovalRequestResponseID,
          WorkflowStepArgument."Approver Type",WorkflowStepArgument."Approver Limit Type",
          WorkflowStepArgument."Workflow User Group Code",WorkflowStepArgument."Approver User ID",
          WorkflowStepArgument."Due Date Formula",ShowConfirmationMessage);
        SendApprovalRequestResponseID := InsertResponseStep(Workflow,RecSendApprovalRequestForApprovalCode,
            CreateApprovalRequestResponseID);
        InsertNotificationArgument(SendApprovalRequestResponseID,'',0,'');

        OnAllRequestsApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        InsertEventArgument(OnAllRequestsApprovedEventID,BuildNoPendingApprovalsConditions);
        InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,OnAllRequestsApprovedEventID);

        OnRequestApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        InsertEventArgument(OnRequestApprovedEventID,BuildPendingApprovalsConditions);
        SendApprovalRequestResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestApprovedEventID);

        SetNextStep(Workflow,SendApprovalRequestResponseID2,SendApprovalRequestResponseID);

        OnRequestRejectedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
            SendApprovalRequestResponseID);
        RejectAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RejectAllApprovalRequestsCode,
            OnRequestRejectedEventID);
        InsertNotificationArgument(RejectAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');

        OnRequestCanceledEventID := InsertEventStep(Workflow,RecCanceledEventCode,SendApprovalRequestResponseID);
        CancelAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CancelAllApprovalRequestsCode,
            OnRequestCanceledEventID);
        InsertNotificationArgument(CancelAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');

        TempResponseResponseID := CancelAllApprovalsResponseID;
        if RemoveRestrictionOnCancel then begin
          AllowRecordUsageResponseID :=
            InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,CancelAllApprovalsResponseID);
          TempResponseResponseID := AllowRecordUsageResponseID;
        end;
        if ShowConfirmationMessage then begin
          ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,TempResponseResponseID);
          InsertMessageArgument(ShowMessageResponseID,ApprovalRequestCanceledMsg);
        end;

        OnRequestDelegatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
            SendApprovalRequestResponseID);
        SentApprovalRequestResponseID3 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestDelegatedEventID);

        SetNextStep(Workflow,SentApprovalRequestResponseID3,SendApprovalRequestResponseID);
    end;


    procedure InsertRecChangedApprovalWorkflowSteps(Workflow: Record Workflow;RuleOperator: Option;RecChangedEventCode: Code[128];RecCreateApprovalRequestsCode: Code[128];RecSendApprovalRequestForApprovalCode: Code[128];var WorkflowStepArgument: Record "Workflow Step Argument";TableNo: Integer;FieldNo: Integer;RecordChangeApprovalMsg: Text)
    var
        CustomerChangedEventID: Integer;
        RevertFieldResponseID: Integer;
        CreateApprovalRequestResponseID: Integer;
        SendApprovalRequestResponseID: Integer;
        OnAllRequestsApprovedEventID: Integer;
        OnRequestApprovedEventID: Integer;
        SendApprovalRequestResponseID2: Integer;
        OnRequestRejectedEventID: Integer;
        RejectAllApprovalsResponseID: Integer;
        DiscardNewValuesResponseID: Integer;
        OnRequestDelegatedEventID: Integer;
        SentApprovalRequestResponseID3: Integer;
        ShowMessageResponseID: Integer;
        ApplyNewValuesResponseID: Integer;
    begin
        CustomerChangedEventID := InsertEntryPointEventStep(Workflow,RecChangedEventCode);
        InsertEventRule(CustomerChangedEventID,FieldNo,RuleOperator);

        RevertFieldResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RevertValueForFieldCode,
            CustomerChangedEventID);
        InsertChangeRecValueArgument(RevertFieldResponseID,TableNo,FieldNo);
        CreateApprovalRequestResponseID := InsertResponseStep(Workflow,RecCreateApprovalRequestsCode,
            RevertFieldResponseID);
        InsertApprovalArgument(CreateApprovalRequestResponseID,WorkflowStepArgument."Approver Type",
          WorkflowStepArgument."Approver Limit Type",WorkflowStepArgument."Workflow User Group Code",
          WorkflowStepArgument."Approver User ID",WorkflowStepArgument."Due Date Formula",false);
        SendApprovalRequestResponseID := InsertResponseStep(Workflow,RecSendApprovalRequestForApprovalCode,
            CreateApprovalRequestResponseID);
        InsertNotificationArgument(SendApprovalRequestResponseID,'',0,'');
        ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,
            SendApprovalRequestResponseID);
        InsertMessageArgument(ShowMessageResponseID,CopyStr(RecordChangeApprovalMsg,1,250));

        OnAllRequestsApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            ShowMessageResponseID);
        InsertEventArgument(OnAllRequestsApprovedEventID,BuildNoPendingApprovalsConditions);
        ApplyNewValuesResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ApplyNewValuesCode,
            OnAllRequestsApprovedEventID);
        InsertChangeRecValueArgument(ApplyNewValuesResponseID,TableNo,FieldNo);

        OnRequestApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            ShowMessageResponseID);
        InsertEventArgument(OnRequestApprovedEventID,BuildPendingApprovalsConditions);
        SendApprovalRequestResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestApprovedEventID);

        SetNextStep(Workflow,SendApprovalRequestResponseID2,ShowMessageResponseID);

        OnRequestRejectedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
            ShowMessageResponseID);
        DiscardNewValuesResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.DiscardNewValuesCode,
            OnRequestRejectedEventID);
        RejectAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RejectAllApprovalRequestsCode,
            DiscardNewValuesResponseID);
        InsertNotificationArgument(RejectAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');

        OnRequestDelegatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
            ShowMessageResponseID);
        SentApprovalRequestResponseID3 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestDelegatedEventID);

        SetNextStep(Workflow,SentApprovalRequestResponseID3,ShowMessageResponseID);
    end;


    procedure InsertGenJnlBatchApprovalWorkflowSteps(Workflow: Record Workflow;ConditionString: Text;RecSendForApprovalEventCode: Code[128];RecCreateApprovalRequestsCode: Code[128];RecSendApprovalRequestForApprovalCode: Code[128];RecCanceledEventCode: Code[128];WorkflowStepArgument: Record "Workflow Step Argument";ShowConfirmationMessage: Boolean)
    var
        SentForApprovalEventID: Integer;
        CheckBatchBalanceResponseID: Integer;
        OnBatchIsBalancedEventID: Integer;
        OnBatchIsNotBalancedEventID: Integer;
        CreateApprovalRequestResponseID: Integer;
        SendApprovalRequestResponseID: Integer;
        OnAllRequestsApprovedEventID: Integer;
        OnRequestApprovedEventID: Integer;
        SendApprovalRequestResponseID2: Integer;
        OnRequestRejectedEventID: Integer;
        RejectAllApprovalsResponseID: Integer;
        OnRequestCanceledEventID: Integer;
        CancelAllApprovalsResponseID: Integer;
        OnRequestDelegatedEventID: Integer;
        SentApprovalRequestResponseID3: Integer;
        ShowMessageResponseID: Integer;
        RestrictUsageResponseID: Integer;
    begin
        SentForApprovalEventID := InsertEntryPointEventStep(Workflow,RecSendForApprovalEventCode);
        InsertEventArgument(SentForApprovalEventID,ConditionString);

        CheckBatchBalanceResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CheckGeneralJournalBatchBalanceCode,
            SentForApprovalEventID);

        OnBatchIsBalancedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnGeneralJournalBatchBalancedCode,
            CheckBatchBalanceResponseID);

        RestrictUsageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RestrictRecordUsageCode,
            OnBatchIsBalancedEventID);
        CreateApprovalRequestResponseID := InsertResponseStep(Workflow,RecCreateApprovalRequestsCode,
            RestrictUsageResponseID);
        InsertApprovalArgument(CreateApprovalRequestResponseID,
          WorkflowStepArgument."Approver Type",WorkflowStepArgument."Approver Limit Type",
          WorkflowStepArgument."Workflow User Group Code",WorkflowStepArgument."Approver User ID",
          WorkflowStepArgument."Due Date Formula",ShowConfirmationMessage);
        SendApprovalRequestResponseID := InsertResponseStep(Workflow,RecSendApprovalRequestForApprovalCode,
            CreateApprovalRequestResponseID);
        InsertNotificationArgument(SendApprovalRequestResponseID,'',0,'');

        OnAllRequestsApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        InsertEventArgument(OnAllRequestsApprovedEventID,BuildNoPendingApprovalsConditions);
        InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,OnAllRequestsApprovedEventID);

        OnRequestApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        InsertEventArgument(OnRequestApprovedEventID,BuildPendingApprovalsConditions);
        SendApprovalRequestResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestApprovedEventID);

        SetNextStep(Workflow,SendApprovalRequestResponseID2,SendApprovalRequestResponseID);

        OnRequestRejectedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
            SendApprovalRequestResponseID);
        RejectAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RejectAllApprovalRequestsCode,
            OnRequestRejectedEventID);
        InsertNotificationArgument(RejectAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');

        OnRequestCanceledEventID := InsertEventStep(Workflow,RecCanceledEventCode,SendApprovalRequestResponseID);
        CancelAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CancelAllApprovalRequestsCode,
            OnRequestCanceledEventID);
        InsertNotificationArgument(CancelAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');
        ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,CancelAllApprovalsResponseID);
        InsertMessageArgument(ShowMessageResponseID,ApprovalRequestCanceledMsg);

        OnRequestDelegatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
            SendApprovalRequestResponseID);
        SentApprovalRequestResponseID3 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestDelegatedEventID);

        SetNextStep(Workflow,SentApprovalRequestResponseID3,SendApprovalRequestResponseID);

        OnBatchIsNotBalancedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnGeneralJournalBatchNotBalancedCode,
            CheckBatchBalanceResponseID);

        ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,OnBatchIsNotBalancedEventID);
        InsertMessageArgument(ShowMessageResponseID,GeneralJournalBatchIsNotBalancedMsg);
    end;


    procedure InsertGenJnlLineApprovalWorkflow(var Workflow: Record Workflow;EventConditions: Text;ApproverType: Option;LimitType: Option;WorkflowUserGroupCode: Code[20];SpecificApprover: Code[50];DueDateFormula: DateFormula)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,ApproverType,LimitType,0,
          WorkflowUserGroupCode,DueDateFormula,true);
        WorkflowStepArgument."Approver User ID" := SpecificApprover;

        InsertRecApprovalWorkflowSteps(Workflow,EventConditions,
          WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode,
          WorkflowStepArgument,
          false,false);
    end;


    procedure InsertPurchaseDocumentApprovalWorkflow(var Workflow: Record Workflow;DocumentType: Option;ApproverType: Option;LimitType: Option;WorkflowUserGroupCode: Code[20];DueDateFormula: DateFormula)
    var
        PurchaseHeader: Record "Purchase Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        case DocumentType of
          PurchaseHeader."document type"::Order:
            InsertWorkflow(Workflow,GetWorkflowCode(PurchOrderApprWorkflowCodeTxt),PurchOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
          PurchaseHeader."document type"::Invoice:
            InsertWorkflow(
              Workflow,GetWorkflowCode(PurchInvoiceApprWorkflowCodeTxt),PurchInvoiceApprWorkflowDescTxt,PurchDocCategoryTxt);
          PurchaseHeader."document type"::"Return Order":
            InsertWorkflow(Workflow,GetWorkflowCode(PurchReturnOrderApprWorkflowCodeTxt),
              PurchReturnOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
          PurchaseHeader."document type"::"Credit Memo":
            InsertWorkflow(Workflow,GetWorkflowCode(PurchCreditMemoApprWorkflowCodeTxt),
              PurchCreditMemoApprWorkflowDescTxt,PurchDocCategoryTxt);
          PurchaseHeader."document type"::Quote:
            InsertWorkflow(Workflow,GetWorkflowCode(PurchQuoteApprWorkflowCodeTxt),PurchQuoteApprWorkflowDescTxt,PurchDocCategoryTxt);
          PurchaseHeader."document type"::"Blanket Order":
            InsertWorkflow(Workflow,GetWorkflowCode(PurchBlanketOrderApprWorkflowCodeTxt),
              PurchBlanketOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
        end;

        PopulateWorkflowStepArgument(WorkflowStepArgument,ApproverType,LimitType,0,
          WorkflowUserGroupCode,DueDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,BuildPurchHeaderTypeConditions(DocumentType,PurchaseHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
          BuildPurchHeaderTypeConditions(DocumentType,PurchaseHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
          WorkflowStepArgument,true);
    end;


    procedure InsertSalesDocumentApprovalWorkflow(var Workflow: Record Workflow;DocumentType: Option;ApproverType: Option;LimitType: Option;WorkflowUserGroupCode: Code[20];DueDateFormula: DateFormula)
    var
        SalesHeader: Record "Sales Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        case DocumentType of
          SalesHeader."document type"::Order:
            InsertWorkflow(Workflow,GetWorkflowCode(SalesOrderApprWorkflowCodeTxt),SalesOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
          SalesHeader."document type"::Invoice:
            InsertWorkflow(Workflow,GetWorkflowCode(SalesInvoiceApprWorkflowCodeTxt),
              SalesInvoiceApprWorkflowDescTxt,SalesDocCategoryTxt);
          SalesHeader."document type"::"Return Order":
            InsertWorkflow(Workflow,GetWorkflowCode(SalesReturnOrderApprWorkflowCodeTxt),
              SalesReturnOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
          SalesHeader."document type"::"Credit Memo":
            InsertWorkflow(Workflow,GetWorkflowCode(SalesCreditMemoApprWorkflowCodeTxt),
              SalesCreditMemoApprWorkflowDescTxt,SalesDocCategoryTxt);
          SalesHeader."document type"::Quote:
            InsertWorkflow(Workflow,GetWorkflowCode(SalesQuoteApprWorkflowCodeTxt),SalesQuoteApprWorkflowDescTxt,SalesDocCategoryTxt);
          SalesHeader."document type"::"Blanket Order":
            InsertWorkflow(Workflow,GetWorkflowCode(SalesBlanketOrderApprWorkflowCodeTxt),
              SalesBlanketOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
        end;

        PopulateWorkflowStepArgument(WorkflowStepArgument,ApproverType,LimitType,0,
          WorkflowUserGroupCode,DueDateFormula,true);

        InsertDocApprovalWorkflowSteps(Workflow,BuildSalesHeaderTypeConditions(DocumentType,SalesHeader.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
          BuildSalesHeaderTypeConditions(DocumentType,SalesHeader.Status::"Pending Approval"),
          WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
          WorkflowStepArgument,true);
    end;


    procedure InsertSalesDocumentCreditLimitApprovalWorkflow(var Workflow: Record Workflow;DocumentType: Option;ApproverType: Option;LimitType: Option;WorkflowUserGroupCode: Code[20];DueDateFormula: DateFormula)
    var
        SalesHeader: Record "Sales Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        case DocumentType of
          SalesHeader."document type"::Order:
            InsertWorkflow(Workflow,GetWorkflowCode(SalesOrderCreditLimitApprWorkflowCodeTxt),
              SalesOrderCreditLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
          SalesHeader."document type"::Invoice:
            InsertWorkflow(Workflow,GetWorkflowCode(SalesInvoiceCreditLimitApprWorkflowCodeTxt),
              SalesInvoiceCreditLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
          SalesHeader."document type"::"Return Order":
            InsertWorkflow(Workflow,GetWorkflowCode(SalesRetOrderCrLimitApprWorkflowCodeTxt),
              SalesRetOrderCrLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
          SalesHeader."document type"::"Credit Memo":
            InsertWorkflow(Workflow,GetWorkflowCode(SalesCrMemoCrLimitApprWorkflowCodeTxt),
              SalesCrMemoCrLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
          SalesHeader."document type"::Quote:
            InsertWorkflow(Workflow,GetWorkflowCode(SalesQuoteCrLimitApprWorkflowCodeTxt),
              SalesQuoteCrLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
          SalesHeader."document type"::"Blanket Order":
            InsertWorkflow(Workflow,GetWorkflowCode(SalesBlanketOrderCrLimitApprWorkflowCodeTxt),
              SalesBlanketOrderCrLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
        end;

        PopulateWorkflowStepArgument(WorkflowStepArgument,ApproverType,LimitType,0,
          WorkflowUserGroupCode,DueDateFormula,true);

        InsertSalesDocWithCreditLimitApprovalWorkflowSteps(Workflow,
          BuildSalesHeaderTypeConditions(DocumentType,SalesHeader.Status::Open),
          BuildSalesHeaderTypeConditions(DocumentType,SalesHeader.Status::"Pending Approval"),WorkflowStepArgument,true);
    end;

    local procedure InsertEntryPointEventStep(Workflow: Record Workflow;FunctionName: Code[128]): Integer
    var
        WorkflowStep: Record "Workflow Step";
    begin
        InsertStep(WorkflowStep,Workflow.Code,WorkflowStep.Type::"Event",FunctionName);
        WorkflowStep.Validate("Entry Point",true);
        WorkflowStep.Modify(true);
        exit(WorkflowStep.ID);
    end;

    local procedure InsertEventStep(Workflow: Record Workflow;FunctionName: Code[128];PreviousStepID: Integer): Integer
    var
        WorkflowStep: Record "Workflow Step";
    begin
        InsertStep(WorkflowStep,Workflow.Code,WorkflowStep.Type::"Event",FunctionName);
        WorkflowStep."Sequence No." := GetSequenceNumber(Workflow,PreviousStepID);
        WorkflowStep.Validate("Previous Workflow Step ID",PreviousStepID);
        WorkflowStep.Modify(true);
        exit(WorkflowStep.ID);
    end;

    local procedure InsertResponseStep(Workflow: Record Workflow;FunctionName: Code[128];PreviousStepID: Integer): Integer
    var
        WorkflowStep: Record "Workflow Step";
    begin
        InsertStep(WorkflowStep,Workflow.Code,WorkflowStep.Type::Response,FunctionName);
        WorkflowStep."Sequence No." := GetSequenceNumber(Workflow,PreviousStepID);
        WorkflowStep.Validate("Previous Workflow Step ID",PreviousStepID);
        WorkflowStep.Modify(true);
        exit(WorkflowStep.ID);
    end;

    local procedure InsertStep(var WorkflowStep: Record "Workflow Step";WorkflowCode: Code[20];StepType: Option;FunctionName: Code[128])
    begin
        with WorkflowStep do begin
          Validate("Workflow Code",WorkflowCode);
          Validate(Type,StepType);
          Validate("Function Name",FunctionName);
          Insert(true);
        end;
    end;

    local procedure MarkWorkflowAsTemplate(var Workflow: Record Workflow)
    begin
        Workflow.Validate(Template,true);
        Workflow.Modify(true);
    end;

    local procedure GetSequenceNumber(Workflow: Record Workflow;PreviousStepID: Integer): Integer
    var
        WorkflowStep: Record "Workflow Step";
    begin
        WorkflowStep.SetRange("Workflow Code",Workflow.Code);
        WorkflowStep.SetRange("Previous Workflow Step ID",PreviousStepID);
        if WorkflowStep.FindLast then
          exit(WorkflowStep."Sequence No." + 1);
    end;

    local procedure SetNextStep(Workflow: Record Workflow;WorkflowStepID: Integer;NextStepID: Integer)
    var
        WorkflowStep: Record "Workflow Step";
    begin
        WorkflowStep.Get(Workflow.Code,WorkflowStepID);
        WorkflowStep.Validate("Next Workflow Step ID",NextStepID);
        WorkflowStep.Modify(true);
    end;


    procedure InsertTableRelation(TableId: Integer;FieldId: Integer;RelatedTableId: Integer;RelatedFieldId: Integer)
    var
        WorkflowTableRelation: Record "Workflow - Table Relation";
    begin
        WorkflowTableRelation.Init;
        WorkflowTableRelation."Table ID" := TableId;
        WorkflowTableRelation."Field ID" := FieldId;
        WorkflowTableRelation."Related Table ID" := RelatedTableId;
        WorkflowTableRelation."Related Field ID" := RelatedFieldId;
        if WorkflowTableRelation.Insert then;
    end;

    local procedure InsertWorkflowCategory("Code": Code[20];Description: Text[100])
    var
        WorkflowCategory: Record "Workflow Category";
    begin
        WorkflowCategory.Init;
        WorkflowCategory.Code := Code;
        WorkflowCategory.Description := Description;
        if WorkflowCategory.Insert then;
    end;

    local procedure InsertEventArgument(WorkflowStepID: Integer;EventConditions: Text)
    var
        WorkflowStep: Record "Workflow Step";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        if EventConditions = '' then
          Error(InvalidEventCondErr);

        WorkflowStepArgument.Type := WorkflowStepArgument.Type::"Event";
        WorkflowStepArgument.Insert(true);
        WorkflowStepArgument.SetEventFilters(EventConditions);

        WorkflowStep.SetRange(ID,WorkflowStepID);
        WorkflowStep.FindFirst;
        WorkflowStep.Argument := WorkflowStepArgument.ID;
        WorkflowStep.Modify(true);
    end;

    local procedure InsertEventRule(WorkflowStepID: Integer;FieldNo: Integer;Operator: Option)
    var
        WorkflowStep: Record "Workflow Step";
        WorkflowRule: Record "Workflow Rule";
        WorkflowEvent: Record "Workflow Event";
    begin
        WorkflowStep.SetRange(ID,WorkflowStepID);
        WorkflowStep.FindFirst;

        WorkflowRule.Init;
        WorkflowRule."Workflow Code" := WorkflowStep."Workflow Code";
        WorkflowRule."Workflow Step ID" := WorkflowStep.ID;
        WorkflowRule.Operator := Operator;

        if WorkflowEvent.Get(WorkflowStep."Function Name") then
          WorkflowRule."Table ID" := WorkflowEvent."Table ID";
        WorkflowRule."Field No." := FieldNo;
        WorkflowRule.Insert(true);
    end;

    local procedure InsertNotificationArgument(WorkflowStepID: Integer;NotifUserID: Code[50];LinkTargetPage: Integer;CustomLink: Text[250])
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        InsertStepArgument(WorkflowStepArgument,WorkflowStepID);

        WorkflowStepArgument."Notification User ID" := NotifUserID;
        WorkflowStepArgument."Link Target Page" := LinkTargetPage;
        WorkflowStepArgument."Custom Link" := CustomLink;
        WorkflowStepArgument.Modify(true);
    end;

    local procedure InsertPmtLineCreationArgument(WorkflowStepID: Integer;GenJnlTemplateName: Code[10];GenJnlBatchName: Code[10])
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        InsertStepArgument(WorkflowStepArgument,WorkflowStepID);

        WorkflowStepArgument."General Journal Template Name" := GenJnlTemplateName;
        WorkflowStepArgument."General Journal Batch Name" := GenJnlBatchName;
        WorkflowStepArgument.Modify(true);
    end;

    local procedure InsertApprovalArgument(WorkflowStepID: Integer;ApproverType: Option;ApproverLimitType: Option;WorkflowUserGroupCode: Code[20];ApproverId: Code[50];DueDateFormula: DateFormula;ShowConfirmationMessage: Boolean)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        InsertStepArgument(WorkflowStepArgument,WorkflowStepID);

        WorkflowStepArgument."Approver Type" := ApproverType;
        WorkflowStepArgument."Approver Limit Type" := ApproverLimitType;
        WorkflowStepArgument."Workflow User Group Code" := WorkflowUserGroupCode;
        WorkflowStepArgument."Approver User ID" := ApproverId;
        WorkflowStepArgument."Due Date Formula" := DueDateFormula;
        WorkflowStepArgument."Show Confirmation Message" := ShowConfirmationMessage;
        WorkflowStepArgument.Modify(true);
    end;

    local procedure InsertMessageArgument(WorkflowStepID: Integer;Message: Text[250])
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        InsertStepArgument(WorkflowStepArgument,WorkflowStepID);

        WorkflowStepArgument.Message := Message;
        WorkflowStepArgument.Modify(true);
    end;

    local procedure InsertChangeRecValueArgument(WorkflowStepID: Integer;TableNo: Integer;FieldNo: Integer)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        InsertStepArgument(WorkflowStepArgument,WorkflowStepID);

        WorkflowStepArgument."Table No." := TableNo;
        WorkflowStepArgument."Field No." := FieldNo;
        WorkflowStepArgument.Modify(true);
    end;

    local procedure InsertStepArgument(var WorkflowStepArgument: Record "Workflow Step Argument";WorkflowStepID: Integer)
    var
        WorkflowStep: Record "Workflow Step";
    begin
        WorkflowStep.SetRange(ID,WorkflowStepID);
        WorkflowStep.FindFirst;

        if WorkflowStepArgument.Get(WorkflowStep.Argument) then
          exit;

        WorkflowStepArgument.Type := WorkflowStepArgument.Type::Response;
        WorkflowStepArgument.Validate("Response Function Name",WorkflowStep."Function Name");
        WorkflowStepArgument.Insert(true);

        WorkflowStep.Argument := WorkflowStepArgument.ID;
        WorkflowStep.Modify(true);
    end;

    local procedure GetWorkflowCode(WorkflowCode: Text): Code[20]
    var
        Workflow: Record Workflow;
    begin
        exit(CopyStr(Format(Workflow.Count + 1) + '-' + WorkflowCode,1,MaxStrLen(Workflow.Code)));
    end;


    procedure GetWorkflowTemplateCode(WorkflowCode: Code[17]): Code[20]
    begin
        exit(MsTemplateTok + WorkflowCode);
    end;


    procedure GetWorkflowTemplateToken(): Code[3]
    begin
        exit(MsTemplateTok);
    end;


    procedure GetWorkflowWizardCode(WorkflowCode: Code[17]): Code[20]
    begin
        exit(MsWizardWorkflowTok + WorkflowCode);
    end;


    procedure GetWorkflowWizardToken(): Code[3]
    begin
        exit(MsWizardWorkflowTok);
    end;


    procedure SetTemplateForWorkflowStep(Workflow: Record Workflow;FunctionName: Code[128])
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowStep: Record "Workflow Step";
    begin
        WorkflowStep.SetRange("Workflow Code",Workflow.Code);
        WorkflowStep.SetRange("Function Name",FunctionName);
        if WorkflowStep.FindSet then
          repeat
            if not WorkflowStepArgument.Get(WorkflowStep.Argument) then
              InsertNotificationArgument(WorkflowStep.ID,'',0,'');
          until WorkflowStep.Next = 0;
    end;

    local procedure PopulateWorkflowStepArgument(var WorkflowStepArgument: Record "Workflow Step Argument";ApproverType: Option;ApproverLimitType: Option;ApprovalEntriesPage: Integer;WorkflowUserGroupCode: Code[20];DueDateFormula: DateFormula;ShowConfirmationMessage: Boolean)
    begin
        WorkflowStepArgument.Init;
        WorkflowStepArgument.Type := WorkflowStepArgument.Type::Response;
        WorkflowStepArgument."Approver Type" := ApproverType;
        WorkflowStepArgument."Approver Limit Type" := ApproverLimitType;
        WorkflowStepArgument."Workflow User Group Code" := WorkflowUserGroupCode;
        WorkflowStepArgument."Due Date Formula" := DueDateFormula;
        WorkflowStepArgument."Link Target Page" := ApprovalEntriesPage;
        WorkflowStepArgument."Show Confirmation Message" := ShowConfirmationMessage;
    end;

    local procedure BuildNoPendingApprovalsConditions(): Text
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Pending Approvals",0);
        exit(StrSubstNo(PendingApprovalsCondnTxt,Encode(ApprovalEntry.GetView(false))));
    end;

    local procedure BuildPendingApprovalsConditions(): Text
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetFilter("Pending Approvals",'>%1',0);
        exit(StrSubstNo(PendingApprovalsCondnTxt,Encode(ApprovalEntry.GetView(false))));
    end;


    procedure BuildIncomingDocumentTypeConditions(Status: Option): Text
    var
        IncomingDocument: Record "Incoming Document";
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
    begin
        IncomingDocument.SetRange(Status,Status);
        exit(
          StrSubstNo(
            IncomingDocumentTypeCondnTxt,Encode(IncomingDocument.GetView(false)),Encode(IncomingDocumentAttachment.GetView(false))));
    end;


    procedure BuildIncomingDocumentOCRTypeConditions(OCRStatus: Option): Text
    var
        IncomingDocument: Record "Incoming Document";
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
    begin
        IncomingDocument.SetRange("OCR Status",OCRStatus);
        exit(
          StrSubstNo(
            IncomingDocumentTypeCondnTxt,Encode(IncomingDocument.GetView(false)),Encode(IncomingDocumentAttachment.GetView(false))));
    end;


    procedure BuildPurchHeaderTypeConditions(DocumentType: Option;Status: Option): Text
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseHeader.SetRange("Document Type",DocumentType);
        PurchaseHeader.SetRange(Status,Status);
        exit(StrSubstNo(PurchHeaderTypeCondnTxt,Encode(PurchaseHeader.GetView(false)),Encode(PurchaseLine.GetView(false))));
    end;


    procedure BuildSalesHeaderTypeConditions(DocumentType: Option;Status: Option): Text
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.SetRange("Document Type",DocumentType);
        SalesHeader.SetRange(Status,Status);
        exit(StrSubstNo(SalesHeaderTypeCondnTxt,Encode(SalesHeader.GetView(false)),Encode(SalesLine.GetView(false))));
    end;


    procedure BuildCustomerTypeConditions(): Text
    var
        Customer: Record Customer;
    begin
        exit(StrSubstNo(CustomerTypeCondnTxt,Encode(Customer.GetView(false))));
    end;


    procedure BuildVendorTypeConditions(): Text
    var
        Vendor: Record Vendor;
    begin
        exit(StrSubstNo(VendorTypeCondnTxt,Encode(Vendor.GetView(false))));
    end;


    procedure BuildItemTypeConditions(): Text
    var
        Item: Record Item;
    begin
        exit(StrSubstNo(ItemTypeCondnTxt,Encode(Item.GetView(false))));
    end;

    local procedure BuildGeneralJournalBatchTypeConditions(): Text
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        exit(BuildGeneralJournalBatchTypeConditionsFromRec(GenJournalBatch));
    end;


    procedure BuildGeneralJournalBatchTypeConditionsFromRec(var GenJournalBatch: Record "Gen. Journal Batch"): Text
    begin
        exit(StrSubstNo(GeneralJournalBatchTypeCondnTxt,Encode(GenJournalBatch.GetView(false))));
    end;


    procedure BuildGeneralJournalLineTypeConditions(var GenJournalLine: Record "Gen. Journal Line"): Text
    begin
        exit(StrSubstNo(GeneralJournalLineTypeCondnTxt,Encode(GenJournalLine.GetView(false))));
    end;

    local procedure InsertJobQueueData()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        CreateJobQueueEntry(JobQueueEntry."object type to run"::Report,Report::"Delegate Approval Requests",CurrentDatetime,1440);
    end;


    procedure CreateJobQueueEntry(ObjectTypeToRun: Option;ObjectIdToRun: Integer;NotBefore: DateTime;NoOfMinutesBetweenRuns: Integer)
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        with JobQueueEntry do begin
          SetRange("Object Type to Run",ObjectTypeToRun);
          SetRange("Object ID to Run",ObjectIdToRun);
          SetRange("Recurring Job",true);
          if not IsEmpty then
            exit;
          Init;
          "Earliest Start Date/Time" := NotBefore;
          "Object Type to Run" := ObjectTypeToRun;
          "Object ID to Run" := ObjectIdToRun;
          "Recurring Job" := true;
          "Run on Mondays" := true;
          "Run on Tuesdays" := true;
          "Run on Wednesdays" := true;
          "Run on Thursdays" := true;
          "Run on Fridays" := true;
          "Run on Saturdays" := true;
          "Run on Sundays" := true;
          "Report Output Type" := "report output type"::"None (Processing only)";
          "No. of Minutes between Runs" := NoOfMinutesBetweenRuns;
          "Maximum No. of Attempts to Run" := 3;
          Codeunit.Run(Codeunit::"Job Queue - Enqueue",JobQueueEntry);
        end;
    end;

    local procedure Encode(Text: Text): Text
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
    begin
        exit(XMLDOMManagement.XMLEscape(Text));
    end;
}

