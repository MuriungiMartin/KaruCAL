#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1520 "Workflow Event Handling"
{

    trigger OnRun()
    begin
    end;

    var
        IncDocReleasedEventDescTxt: label 'An incoming document is released.';
        CreateDocFromIncDocSuccessfulEventDescTxt: label 'Creating a document from an incoming document is successful.';
        CreateDocFromIncDocFailsEventDescTxt: label 'Creating a document from an incoming document fails.';
        IncDocCreatedEventDescTxt: label 'An incoming document is created.';
        IncDocIsReadyForOCREventDescTxt: label 'An incoming document is ready for OCR.';
        IncDocIsSentForOCREventDescTxt: label 'An incoming document is sent for OCR.';
        IncDocIsReceivedFromOCREventDescTxt: label 'An incoming document is received from OCR.';
        IncDocIsReceivedFromDocExchEventDescTxt: label 'An incoming document is received from document exchange.';
        IncDocSendForApprovalEventDescTxt: label 'Approval of a incoming document is requested.';
        IncDocApprReqCancelledEventDescTxt: label 'An approval request for an incoming document is canceled.';
        PurchDocSendForApprovalEventDescTxt: label 'Approval of a purchase document is requested.';
        PurchDocApprReqCancelledEventDescTxt: label 'An approval request for a purchase document is canceled.';
        PurchInvPostEventDescTxt: label 'A purchase invoice is posted.';
        PurchDocReleasedEventDescTxt: label 'A purchase document is released.';
        PurchInvPmtCreatedEventDescTxt: label 'A general journal line is created.';
        ApprReqApprovedEventDescTxt: label 'An approval request is approved.';
        ApprReqRejectedEventDescTxt: label 'An approval request is rejected.';
        ApprReqDelegatedEventDescTxt: label 'An approval request is delegated.';
        SalesDocSendForApprovalEventDescTxt: label 'Approval of a sales document is requested.';
        SalesDocApprReqCancelledEventDescTxt: label 'An approval request for a sales document is canceled.';
        SalesDocReleasedEventDescTxt: label 'A sales document is released.';
        EventAlreadyExistErr: label 'An event with description %1 already exists.';
        SendOverdueNotifTxt: label 'The overdue approval notifications batch job will be run.';
        CustomerCreditLimitExceededTxt: label 'A customer credit limit is exceeded.';
        CustomerCreditLimitNotExceededTxt: label 'A customer credit limit is not exceeded.';
        CustomerSendForApprovalEventDescTxt: label 'Approval of a customer is requested.';
        VendorSendForApprovalEventDescTxt: label 'Approval of a vendor is requested.';
        ItemSendForApprovalEventDescTxt: label 'Approval of an item is requested.';
        CustomerApprovalRequestCancelEventDescTxt: label 'An approval request for a customer is canceled.';
        VendorApprovalRequestCancelEventDescTxt: label 'An approval request for a vendor is canceled.';
        ItemApprovalRequestCancelEventDescTxt: label 'An approval request for an item is canceled.';
        WorkflowManagement: Codeunit "Workflow Management";
        GeneralJournalBatchSendForApprovalEventDescTxt: label 'Approval of a general journal batch is requested.';
        GeneralJournalBatchApprovalRequestCancelEventDescTxt: label 'An approval request for a general journal batch is canceled.';
        GeneralJournalLineSendForApprovalEventDescTxt: label 'Approval of a general journal line is requested.';
        GeneralJournalLineApprovalRequestCancelEventDescTxt: label 'An approval request for a general journal line is canceled.';
        GeneralJournalBatchBalancedEventDescTxt: label 'A general journal batch is balanced.';
        GeneralJournalBatchNotBalancedEventDescTxt: label 'A general journal batch is not balanced.';
        ImageOrPDFIsAttachedToAnIncomingDocEventDescTxt: label 'An image or pdf is attached to a new incoming document for OCR.';
        CustChangedTxt: label 'A customer record is changed.s';
        VendChangedTxt: label 'A vendor record is changed.';
        ItemChangedTxt: label 'An item record is changed.';
        CreateGenJnlLineFromIncDocSuccessfulEventDescTxt: label 'The creation of a general journal line from the incoming document was successful.';
        CreateGenJnlLineFromIncDocFailsEventDescTxt: label 'The creation of a general journal line from the incoming document failed.';
        SpecialExamSendForApprovalTxT: label 'Special Exam Details Approval Is Requested';
        SpecialExamApprovalIsCancelled: label 'Special Exam Details Approval Is Cancelled';


    procedure CreateEventsLibrary()
    begin
        AddEventToLibrary(
          RunWorkflowOnAfterInsertIncomingDocumentCode,Database::"Incoming Document",IncDocCreatedEventDescTxt,0,false);
        AddEventToLibrary(
          RunWorkflowOnAfterReleaseIncomingDocCode,Database::"Incoming Document",IncDocReleasedEventDescTxt,0,false);
        AddEventToLibrary(
          RunWorkflowOnAfterCreateDocFromIncomingDocSuccessCode,
          Database::"Incoming Document",CreateDocFromIncDocSuccessfulEventDescTxt,0,false);
        AddEventToLibrary(
          RunWorkflowOnAfterCreateDocFromIncomingDocFailCode,Database::"Incoming Document",CreateDocFromIncDocFailsEventDescTxt,0,false);
        AddEventToLibrary(
          RunWorkflowOnAfterReadyForOCRIncomingDocCode,Database::"Incoming Document",IncDocIsReadyForOCREventDescTxt,0,false);
        AddEventToLibrary(
          RunWorkflowOnAfterSendToOCRIncomingDocCode,Database::"Incoming Document",IncDocIsSentForOCREventDescTxt,0,false);
        AddEventToLibrary(
          RunWorkflowOnAfterReceiveFromOCRIncomingDocCode,Database::"Incoming Document",IncDocIsReceivedFromOCREventDescTxt,0,false);
        AddEventToLibrary(
          RunWorkflowOnAfterReceiveFromDocExchIncomingDocCode,
          Database::"Incoming Document",IncDocIsReceivedFromDocExchEventDescTxt,0,false);

        AddEventToLibrary(
          RunWorkflowOnSendPurchaseDocForApprovalCode,Database::"Purchase Header",PurchDocSendForApprovalEventDescTxt,0,false);
        AddEventToLibrary(
          RunWorkflowOnSendIncomingDocForApprovalCode,Database::"Incoming Document",IncDocSendForApprovalEventDescTxt,0,false);
        AddEventToLibrary(
          RunWorkflowOnCancelIncomingDocApprovalRequestCode,Database::"Incoming Document",IncDocApprReqCancelledEventDescTxt,0,false);

        ///Special Examinations
        AddEventToLibrary(
          RunWorkflowOnSendSpecialExamApprovalRequestCode,Database::"Aca-Special Exams Details",SpecialExamSendForApprovalTxT,0,false);
          AddEventToLibrary(
          RunWorkflowOnCancelSpecialExamApprovalRequestCode,Database::"Aca-Special Exams Details",SpecialExamApprovalIsCancelled,0,false);

        AddEventToLibrary(RunWorkflowOnCancelPurchaseApprovalRequestCode,Database::"Purchase Header",
          PurchDocApprReqCancelledEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnAfterReleasePurchaseDocCode,Database::"Purchase Header",
          PurchDocReleasedEventDescTxt,0,false);
        AddEventToLibrary(RunWorkflowOnAfterPostPurchaseDocCode,Database::"Purch. Inv. Header",
          PurchInvPostEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnSendSalesDocForApprovalCode,Database::"Sales Header",
          SalesDocSendForApprovalEventDescTxt,0,false);
        AddEventToLibrary(RunWorkflowOnCancelSalesApprovalRequestCode,Database::"Sales Header",
          SalesDocApprReqCancelledEventDescTxt,0,false);
        AddEventToLibrary(RunWorkflowOnAfterReleaseSalesDocCode,Database::"Sales Header",
          SalesDocReleasedEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnAfterInsertGeneralJournalLineCode,Database::"Gen. Journal Line",
          PurchInvPmtCreatedEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnApproveApprovalRequestCode,Database::"Approval Entry",ApprReqApprovedEventDescTxt,0,false);
        AddEventToLibrary(RunWorkflowOnRejectApprovalRequestCode,Database::"Approval Entry",ApprReqRejectedEventDescTxt,0,false);
        AddEventToLibrary(RunWorkflowOnDelegateApprovalRequestCode,Database::"Approval Entry",ApprReqDelegatedEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnSendOverdueNotificationsCode,Database::"Approval Entry",SendOverdueNotifTxt,0,false);

        AddEventToLibrary(RunWorkflowOnCustomerCreditLimitExceededCode,Database::"Sales Header",
          CustomerCreditLimitExceededTxt,0,false);
        AddEventToLibrary(RunWorkflowOnCustomerCreditLimitNotExceededCode,Database::"Sales Header",
          CustomerCreditLimitNotExceededTxt,0,false);

        AddEventToLibrary(RunWorkflowOnSendCustomerForApprovalCode,Database::Customer,
          CustomerSendForApprovalEventDescTxt,0,false);
        AddEventToLibrary(RunWorkflowOnCancelCustomerApprovalRequestCode,Database::Customer,
          CustomerApprovalRequestCancelEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnSendVendorForApprovalCode,Database::Vendor,
          VendorSendForApprovalEventDescTxt,0,false);
        AddEventToLibrary(RunWorkflowOnCancelVendorApprovalRequestCode,Database::Vendor,
          VendorApprovalRequestCancelEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnSendItemForApprovalCode,Database::Item,
          ItemSendForApprovalEventDescTxt,0,false);
        AddEventToLibrary(RunWorkflowOnCancelItemApprovalRequestCode,Database::Item,
          ItemApprovalRequestCancelEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnSendGeneralJournalBatchForApprovalCode,Database::"Gen. Journal Batch",
          GeneralJournalBatchSendForApprovalEventDescTxt,0,false);
        AddEventToLibrary(RunWorkflowOnCancelGeneralJournalBatchApprovalRequestCode,Database::"Gen. Journal Batch",
          GeneralJournalBatchApprovalRequestCancelEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnSendGeneralJournalLineForApprovalCode,Database::"Gen. Journal Line",
          GeneralJournalLineSendForApprovalEventDescTxt,0,false);
        AddEventToLibrary(RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode,Database::"Gen. Journal Line",
          GeneralJournalLineApprovalRequestCancelEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnGeneralJournalBatchBalancedCode,Database::"Gen. Journal Batch",
          GeneralJournalBatchBalancedEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnGeneralJournalBatchNotBalancedCode,Database::"Gen. Journal Batch",
          GeneralJournalBatchNotBalancedEventDescTxt,0,false);

        AddEventToLibrary(
          RunWorkflowOnBinaryFileAttachedCode,
          Database::"Incoming Document Attachment",ImageOrPDFIsAttachedToAnIncomingDocEventDescTxt,0,false);

        AddEventToLibrary(RunWorkflowOnCustomerChangedCode,Database::Customer,CustChangedTxt,0,true);
        AddEventToLibrary(RunWorkflowOnVendorChangedCode,Database::Vendor,VendChangedTxt,0,true);
        AddEventToLibrary(RunWorkflowOnItemChangedCode,Database::Item,ItemChangedTxt,0,true);

        AddEventToLibrary(
          RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocSuccessCode,Database::"Incoming Document",
          CreateGenJnlLineFromIncDocSuccessfulEventDescTxt,0,false);
        AddEventToLibrary(
          RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocFailCode,Database::"Incoming Document",
          CreateGenJnlLineFromIncDocFailsEventDescTxt,0,false);

        OnAddWorkflowEventsToLibrary;
        OnAddWorkflowTableRelationsToLibrary;
    end;

    local procedure AddEventPredecessors(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
          RunWorkflowOnAfterPostPurchaseDocCode:
            AddEventPredecessor(RunWorkflowOnAfterPostPurchaseDocCode,RunWorkflowOnAfterReleasePurchaseDocCode);
          RunWorkflowOnCancelIncomingDocApprovalRequestCode:
            AddEventPredecessor(RunWorkflowOnCancelIncomingDocApprovalRequestCode,RunWorkflowOnSendIncomingDocForApprovalCode);
          RunWorkflowOnCancelPurchaseApprovalRequestCode:
            AddEventPredecessor(RunWorkflowOnCancelPurchaseApprovalRequestCode,RunWorkflowOnSendPurchaseDocForApprovalCode);
          RunWorkflowOnCancelSalesApprovalRequestCode:
            AddEventPredecessor(RunWorkflowOnCancelSalesApprovalRequestCode,RunWorkflowOnSendSalesDocForApprovalCode);
          RunWorkflowOnCancelCustomerApprovalRequestCode:
            AddEventPredecessor(RunWorkflowOnCancelCustomerApprovalRequestCode,RunWorkflowOnSendCustomerForApprovalCode);
          RunWorkflowOnCancelVendorApprovalRequestCode:
            AddEventPredecessor(RunWorkflowOnCancelVendorApprovalRequestCode,RunWorkflowOnSendVendorForApprovalCode);
          RunWorkflowOnCancelItemApprovalRequestCode:
            AddEventPredecessor(RunWorkflowOnCancelItemApprovalRequestCode,RunWorkflowOnSendItemForApprovalCode);
          RunWorkflowOnCancelGeneralJournalBatchApprovalRequestCode:
            AddEventPredecessor(RunWorkflowOnCancelGeneralJournalBatchApprovalRequestCode,
              RunWorkflowOnSendGeneralJournalBatchForApprovalCode);
          RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode:
            AddEventPredecessor(RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode,
              RunWorkflowOnSendGeneralJournalLineForApprovalCode);
          RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode:
            AddEventPredecessor(RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode,
              RunWorkflowOnGeneralJournalBatchBalancedCode);
          RunWorkflowOnCustomerCreditLimitExceededCode:
            AddEventPredecessor(RunWorkflowOnCustomerCreditLimitExceededCode,RunWorkflowOnSendSalesDocForApprovalCode);
          RunWorkflowOnCustomerCreditLimitNotExceededCode:
            AddEventPredecessor(RunWorkflowOnCustomerCreditLimitNotExceededCode,RunWorkflowOnSendSalesDocForApprovalCode);
          RunWorkflowOnApproveApprovalRequestCode:
            begin
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendIncomingDocForApprovalCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendPurchaseDocForApprovalCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendSalesDocForApprovalCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendCustomerForApprovalCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendVendorForApprovalCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendItemForApprovalCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendGeneralJournalBatchForApprovalCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnGeneralJournalBatchBalancedCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendGeneralJournalLineForApprovalCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnCustomerChangedCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnVendorChangedCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnItemChangedCode);
              AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendSpecialExamApprovalRequestCode);
            end;
          RunWorkflowOnRejectApprovalRequestCode:
            begin
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendIncomingDocForApprovalCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendPurchaseDocForApprovalCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendSalesDocForApprovalCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendCustomerForApprovalCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendVendorForApprovalCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendItemForApprovalCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendGeneralJournalBatchForApprovalCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnGeneralJournalBatchBalancedCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendGeneralJournalLineForApprovalCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnCustomerChangedCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnVendorChangedCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnItemChangedCode);
              AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendSpecialExamApprovalRequestCode);
            end;
          RunWorkflowOnDelegateApprovalRequestCode:
            begin
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendIncomingDocForApprovalCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendPurchaseDocForApprovalCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendSalesDocForApprovalCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendCustomerForApprovalCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendVendorForApprovalCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendItemForApprovalCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendGeneralJournalBatchForApprovalCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnGeneralJournalBatchBalancedCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendGeneralJournalLineForApprovalCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnCustomerChangedCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnVendorChangedCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnItemChangedCode);
              AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendSpecialExamApprovalRequestCode);
            end;
          RunWorkflowOnGeneralJournalBatchBalancedCode:
            AddEventPredecessor(RunWorkflowOnGeneralJournalBatchBalancedCode,RunWorkflowOnSendGeneralJournalBatchForApprovalCode);
          RunWorkflowOnGeneralJournalBatchNotBalancedCode:
            AddEventPredecessor(RunWorkflowOnGeneralJournalBatchNotBalancedCode,RunWorkflowOnSendGeneralJournalBatchForApprovalCode);
        end;

        OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName);
    end;


    procedure AddEventToLibrary(FunctionName: Code[128];TableID: Integer;Description: Text[250];RequestPageID: Integer;UsedForRecordChange: Boolean)
    var
        WorkflowEvent: Record "Workflow Event";
    begin
        if WorkflowEvent.Get(FunctionName) then
          exit;

        WorkflowEvent.SetRange(Description,Description);
        if not WorkflowEvent.IsEmpty then
          Error(EventAlreadyExistErr,Description);

        WorkflowEvent.Init;
        WorkflowEvent."Function Name" := FunctionName;
        WorkflowEvent."Table ID" := TableID;
        WorkflowEvent.Description := Description;
        WorkflowEvent."Request Page ID" := RequestPageID;
        WorkflowEvent."Used for Record Change" := UsedForRecordChange;
        WorkflowEvent.Insert;

        AddEventPredecessors(WorkflowEvent."Function Name");
    end;


    procedure AddEventPredecessor(FunctionName: Code[128];PredecessorFunctionName: Code[128])
    var
        WFEventResponseCombination: Record "WF Event/Response Combination";
    begin
        WFEventResponseCombination.Init;
        WFEventResponseCombination.Type := WFEventResponseCombination.Type::"Event";
        WFEventResponseCombination."Function Name" := FunctionName;
        WFEventResponseCombination."Predecessor Type" := WFEventResponseCombination."predecessor type"::"Event";
        WFEventResponseCombination."Predecessor Function Name" := PredecessorFunctionName;
        if WFEventResponseCombination.Insert then;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAddWorkflowTableRelationsToLibrary()
    begin
    end;


    procedure RunWorkflowOnAfterInsertIncomingDocumentCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterInsertIncomingDocument'));
    end;


    procedure RunWorkflowOnAfterReleaseIncomingDocCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterReleaseIncomingDoc'));
    end;


    procedure RunWorkflowOnAfterCreateDocFromIncomingDocSuccessCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterCreateDocFromIncomingDocSuccess'));
    end;


    procedure RunWorkflowOnAfterCreateDocFromIncomingDocFailCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterCreateDocFromIncomingDocFail'));
    end;


    procedure RunWorkflowOnAfterReadyForOCRIncomingDocCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterreadyforOCRIncomingDoc'));
    end;


    procedure RunWorkflowOnAfterSendToOCRIncomingDocCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterSendToOCRIncomingDoc'));
    end;


    procedure RunWorkflowOnAfterReceiveFromOCRIncomingDocCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterReceiveFromOCRIncomingDoc'));
    end;


    procedure RunWorkflowOnAfterReceiveFromDocExchIncomingDocCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterReceiveFromDocExchIncomingDoc'));
    end;


    procedure RunWorkflowOnSendPurchaseDocForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendPurchaseDocForApproval'));
    end;


    procedure RunWorkflowOnSendIncomingDocForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendIncomingDocForApproval'));
    end;


    procedure RunWorkflowOnCancelIncomingDocApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelIncomingDocApprovalRequest'));
    end;


    procedure RunWorkflowOnCancelPurchaseApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelPurchaseApprovalRequest'));
    end;


    procedure RunWorkflowOnAfterReleasePurchaseDocCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterReleasePurchaseDoc'));
    end;


    procedure RunWorkflowOnSendSalesDocForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendSalesDocForApproval'));
    end;


    procedure RunWorkflowOnCancelSalesApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelSalesApprovalRequest'));
    end;


    procedure RunWorkflowOnAfterReleaseSalesDocCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterReleaseSalesDoc'));
    end;


    procedure RunWorkflowOnAfterPostPurchaseDocCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterPostPurchaseDoc'));
    end;


    procedure RunWorkflowOnAfterInsertGeneralJournalLineCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterInsertGeneralJournalLine'));
    end;


    procedure RunWorkflowOnApproveApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveApprovalRequest'));
    end;


    procedure RunWorkflowOnDelegateApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateApprovalRequest'));
    end;


    procedure RunWorkflowOnRejectApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectApprovalRequest'));
    end;


    procedure RunWorkflowOnSendOverdueNotificationsCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendOverdueNotifications'));
    end;


    procedure RunWorkflowOnCustomerCreditLimitExceededCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCustomerCreditLimitExceeded'));
    end;


    procedure RunWorkflowOnCustomerCreditLimitNotExceededCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCustomerCreditLimitNotExceeded'));
    end;


    procedure RunWorkflowOnSendCustomerForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendCustomerForApproval'));
    end;


    procedure RunWorkflowOnSendVendorForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendVendorForApproval'));
    end;


    procedure RunWorkflowOnSendItemForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendItemForApproval'));
    end;


    procedure RunWorkflowOnCancelCustomerApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelCustomerApprovalRequest'));
    end;


    procedure RunWorkflowOnCancelVendorApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelVendorApprovalRequest'));
    end;


    procedure RunWorkflowOnCancelItemApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelItemApprovalRequest'));
    end;


    procedure RunWorkflowOnSendGeneralJournalBatchForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendGeneralJournalBatchForApproval'));
    end;


    procedure RunWorkflowOnCancelGeneralJournalBatchApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelGeneralJournalBatchApprovalRequest'));
    end;


    procedure RunWorkflowOnSendGeneralJournalLineForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendGeneralJournalLineForApproval'));
    end;


    procedure RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelGeneralJournalLineApprovalRequest'));
    end;


    procedure RunWorkflowOnGeneralJournalBatchBalancedCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnGeneralJournalBatchBalanced'));
    end;


    procedure RunWorkflowOnGeneralJournalBatchNotBalancedCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnGeneralJournalBatchNotBalanced'));
    end;


    procedure RunWorkflowOnBinaryFileAttachedCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnBinaryFileAttached'));
    end;


    procedure RunWorkflowOnCustomerChangedCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCustomerChangedCode'));
    end;


    procedure RunWorkflowOnVendorChangedCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnVendorChangedCode'));
    end;


    procedure RunWorkflowOnItemChangedCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnItemChangedCode'));
    end;


    procedure RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocSuccessCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocSuccessCode'));
    end;


    procedure RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocFailCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterCreateGenJnlLineFromIncomingDoFailCode'));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Incoming Document", 'OnAfterInsertEvent', '', false, false)]

    procedure RunWorkflowOnAfterInsertIncomingDocument(var Rec: Record "Incoming Document";RunTrigger: Boolean)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterInsertIncomingDocumentCode,Rec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendPurchaseDocForApproval', '', false, false)]

    procedure RunWorkflowOnSendPurchaseDocForApproval(var PurchaseHeader: Record "Purchase Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPurchaseDocForApprovalCode,PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelPurchaseApprovalRequest', '', false, false)]

    procedure RunWorkflowOnCancelPurchaseApprovalRequest(var PurchaseHeader: Record "Purchase Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPurchaseApprovalRequestCode,PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendIncomingDocForApproval', '', false, false)]

    procedure RunWorkflowOnSendIncomingDocForApproval(var IncomingDocument: Record "Incoming Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendIncomingDocForApprovalCode,IncomingDocument);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelIncomingDocApprovalRequest', '', false, false)]

    procedure RunWorkflowOnCancelIncomingDocApprovalRequest(var IncomingDocument: Record "Incoming Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelIncomingDocApprovalRequestCode,IncomingDocument);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterReleasePurchaseDoc', '', false, false)]

    procedure RunWorkflowOnAfterReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header";PreviewMode: Boolean)
    begin
        if not PreviewMode then
          WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleasePurchaseDocCode,PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendSalesDocForApproval', '', false, false)]

    procedure RunWorkflowOnSendSalesDocForApproval(var SalesHeader: Record "Sales Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendSalesDocForApprovalCode,SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelSalesApprovalRequest', '', false, false)]

    procedure RunWorkflowOnCancelSalesApprovalRequest(var SalesHeader: Record "Sales Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelSalesApprovalRequestCode,SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]

    procedure RunWorkflowOnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header";PreviewMode: Boolean)
    begin
        if not PreviewMode then
          WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseSalesDocCode,SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Incoming Document", 'OnAfterReleaseIncomingDoc', '', false, false)]

    procedure RunWorkflowOnAfterReleaseIncomingDoc(var IncomingDocument: Record "Incoming Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseIncomingDocCode,IncomingDocument);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Incoming Document", 'OnAfterCreateDocFromIncomingDocSuccess', '', false, false)]

    procedure RunWorkflowOnAfterCreateDocFromIncomingDocSuccess(var IncomingDocument: Record "Incoming Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterCreateDocFromIncomingDocSuccessCode,IncomingDocument);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Incoming Document", 'OnAfterCreateDocFromIncomingDocFail', '', false, false)]

    procedure RunWorkflowOnAfterCreateDocFromIncomingDocFail(var IncomingDocument: Record "Incoming Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterCreateDocFromIncomingDocFailCode,IncomingDocument);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Send Incoming Document to OCR", 'OnAfterIncomingDocReadyForOCR', '', false, false)]

    procedure RunWorkflowOnAfterIncomingDocReadyForOCR(var IncomingDocument: Record "Incoming Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReadyForOCRIncomingDocCode,IncomingDocument);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Send Incoming Document to OCR", 'OnAfterIncomingDocSentToOCR', '', false, false)]

    procedure RunWorkflowOnAfterIncomingDocSentToOCR(var IncomingDocument: Record "Incoming Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterSendToOCRIncomingDocCode,IncomingDocument);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Send Incoming Document to OCR", 'OnAfterIncomingDocReceivedFromOCR', '', false, false)]

    procedure RunWorkflowOnAfterIncomingDocReceivedFromOCR(var IncomingDocument: Record "Incoming Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReceiveFromOCRIncomingDocCode,IncomingDocument);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Doc. Exch. Service Mgt.", 'OnAfterIncomingDocReceivedFromDocExch', '', false, false)]

    procedure RunWorkflowOnAfterIncomingDocReceivedFromDocExch(var IncomingDocument: Record "Incoming Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReceiveFromDocExchIncomingDocCode,IncomingDocument);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]

    procedure RunWorkflowOnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header";var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";PurchRcpHdrNo: Code[20];RetShptHdrNo: Code[20];PurchInvHdrNo: Code[20];PurchCrMemoHdrNo: Code[20])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        case PurchaseHeader."Document Type" of
          PurchaseHeader."document type"::Order,PurchaseHeader."document type"::Invoice:
            begin
              if PurchInvHeader.Get(PurchInvHdrNo) then
                WorkflowManagement.HandleEvent(RunWorkflowOnAfterPostPurchaseDocCode,PurchInvHeader);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterInsertEvent', '', false, false)]

    procedure RunWorkflowOnAfterInsertGeneralJournalLine(var Rec: Record "Gen. Journal Line";RunTrigger: Boolean)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterInsertGeneralJournalLineCode,Rec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]

    procedure RunWorkflowOnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestCode,
          ApprovalEntry,ApprovalEntry."Workflow Step Instance ID");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', false, false)]

    procedure RunWorkflowOnDelegateApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateApprovalRequestCode,
          ApprovalEntry,ApprovalEntry."Workflow Step Instance ID");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]

    procedure RunWorkflowOnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectApprovalRequestCode,
          ApprovalEntry,ApprovalEntry."Workflow Step Instance ID");
    end;

    [EventSubscriber(Objecttype::Report, 1509, 'OnSendOverdueNotifications', '', false, false)]

    procedure RunWorkflowOnSendOverdueNotifications()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Init;
        WorkflowManagement.HandleEvent(RunWorkflowOnSendOverdueNotificationsCode,ApprovalEntry);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCustomerCreditLimitExceeded', '', false, false)]

    procedure RunWorkflowOnCustomerCreditLimitExceeded(var Sender: Record "Sales Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCustomerCreditLimitExceededCode,Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCustomerCreditLimitNotExceeded', '', false, false)]

    procedure RunWorkflowOnCustomerCreditLimitNotExceeded(var Sender: Record "Sales Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCustomerCreditLimitNotExceededCode,Sender);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendCustomerForApproval', '', false, false)]

    procedure RunWorkflowOnSendCustomerForApproval(Customer: Record Customer)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendCustomerForApprovalCode,Customer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendVendorForApproval', '', false, false)]

    procedure RunWorkflowOnSendVendorForApproval(Vendor: Record Vendor)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendVendorForApprovalCode,Vendor);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendItemForApproval', '', false, false)]

    procedure RunWorkflowOnSendItemForApproval(Item: Record Item)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendItemForApprovalCode,Item);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelCustomerApprovalRequest', '', false, false)]

    procedure RunWorkflowOnCancelCustomerApprovalRequest(Customer: Record Customer)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelCustomerApprovalRequestCode,Customer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelVendorApprovalRequest', '', false, false)]

    procedure RunWorkflowOnCancelVendorApprovalRequest(Vendor: Record Vendor)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelVendorApprovalRequestCode,Vendor);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelItemApprovalRequest', '', false, false)]

    procedure RunWorkflowOnCancelItemApprovalRequest(Item: Record Item)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelItemApprovalRequestCode,Item);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendGeneralJournalBatchForApproval', '', false, false)]

    procedure RunWorkflowOnSendGeneralJournalBatchForApproval(var GenJournalBatch: Record "Gen. Journal Batch")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendGeneralJournalBatchForApprovalCode,GenJournalBatch);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelGeneralJournalBatchApprovalRequest', '', false, false)]

    procedure RunWorkflowOnCancelGeneralJournalBatchApprovalRequest(var GenJournalBatch: Record "Gen. Journal Batch")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelGeneralJournalBatchApprovalRequestCode,GenJournalBatch);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendGeneralJournalLineForApproval', '', false, false)]

    procedure RunWorkflowOnSendGeneralJournalLineForApproval(var GenJournalLine: Record "Gen. Journal Line")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendGeneralJournalLineForApprovalCode,GenJournalLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelGeneralJournalLineApprovalRequest', '', false, false)]

    procedure RunWorkflowOnCancelGeneralJournalLineApprovalRequest(var GenJournalLine: Record "Gen. Journal Line")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode,GenJournalLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Batch", 'OnGeneralJournalBatchBalanced', '', false, false)]

    procedure RunWorkflowOnGeneralJournalBatchBalanced(var Sender: Record "Gen. Journal Batch")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnGeneralJournalBatchBalancedCode,Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Batch", 'OnGeneralJournalBatchNotBalanced', '', false, false)]

    procedure RunWorkflowOnGeneralJournalBatchNotBalanced(var Sender: Record "Gen. Journal Batch")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnGeneralJournalBatchNotBalancedCode,Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Incoming Document Attachment", 'OnAttachBinaryFile', '', false, false)]

    procedure RunWorkflowOnBinaryFileAttached(var Sender: Record "Incoming Document Attachment")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnBinaryFileAttachedCode,Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterModifyEvent', '', false, false)]

    procedure RunWorkflowOnCustomerChanged(var Rec: Record Customer;var xRec: Record Customer;RunTrigger: Boolean)
    begin
        if Format(xRec) <> Format(Rec) then
          WorkflowManagement.HandleEventWithxRec(RunWorkflowOnCustomerChangedCode,Rec,xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterModifyEvent', '', false, false)]

    procedure RunWorkflowOnVendorChanged(var Rec: Record Vendor;var xRec: Record Vendor;RunTrigger: Boolean)
    begin
        if Format(xRec) <> Format(Rec) then
          WorkflowManagement.HandleEventWithxRec(RunWorkflowOnVendorChangedCode,Rec,xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterModifyEvent', '', false, false)]

    procedure RunWorkflowOnItemChanged(var Rec: Record Item;var xRec: Record Item;RunTrigger: Boolean)
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
    begin
        if GenJnlPostPreview.IsActive then
          exit;

        if Format(xRec) <> Format(Rec) then
          WorkflowManagement.HandleEventWithxRec(RunWorkflowOnItemChangedCode,Rec,xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Incoming Document", 'OnAfterCreateGenJnlLineFromIncomingDocSuccess', '', false, false)]

    procedure RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocSuccess(var IncomingDocument: Record "Incoming Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocSuccessCode,IncomingDocument);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Incoming Document", 'OnAfterCreateGenJnlLineFromIncomingDocFail', '', false, false)]

    procedure RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocFail(var IncomingDocument: Record "Incoming Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocFailCode,IncomingDocument);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendSpecialExamForApproval', '', false, false)]

    procedure RunWorkflowOnSendSpecialExamApprovalRequest(var SpecialExamDetails: Record UnknownRecord78002)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendSpecialExamApprovalRequestCode,SpecialExamDetails);
    end;


    procedure RunWorkflowOnCancelSpecialExamApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelSpecialExamApprovalRequest'));
    end;


    procedure RunWorkflowOnSendSpecialExamApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendSpecialExamApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCanceSpecialExamApprovalRequest', '', false, false)]

    procedure RunWorkflowOnCancelSpecialExamApprovalRequest(var SpecialExamDetails: Record UnknownRecord78002)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelSpecialExamApprovalRequestCode,SpecialExamDetails);
    end;
}

