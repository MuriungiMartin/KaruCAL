#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1521 "Workflow Response Handling"
{
    Permissions = TableData "Sales Header"=rm,
                  TableData "Purchase Header"=rm,
                  TableData "Notification Entry"=imd;

    trigger OnRun()
    begin
    end;

    var
        NotSupportedResponseErr: label 'Response %1 is not supported in the workflow.';
        CreateNotifEntryTxt: label 'Create a notification for %1.', Comment='Create a notification for NAVUser.';
        CreatePmtLineAsyncTxt: label 'Create a payment journal line in the background for journal template %1 and journal batch %2.', Comment='Create a payment journal line in the background for journal template GENERAL and journal batch DEFAULT.';
        CreatePmtLineTxt: label 'Create a payment journal line for journal template %1 and journal batch %2.', Comment='Create a payment journal line for journal template GENERAL and journal batch DEFAULT.';
        DoNothingTxt: label 'Do nothing.';
        CreateApprovalRequestsTxt: label 'Create an approval request for the record using approver type %1 and %2.', Comment='Create an approval request for the record using approver type Approver and approver limit type Direct Approver.';
        CreateApprovalWorkflowGroupTxt: label 'workflow user group code %1', Comment='%1 = Workflow user group code';
        CreateApprovalApprovalLimitTxt: label 'approver limit type %1', Comment='%1 = Approval limit type';
        GetApprovalCommentTxt: label 'Open Approval Comments page.';
        OpenDocumentTxt: label 'Reopen the document.';
        ReleaseDocumentTxt: label 'Release the document.';
        SendApprReqForApprovalTxt: label 'Send approval request for the record and create a notification.';
        ApproveAllApprReqTxt: label 'Approve the approval request for the record.';
        RejectAllApprReqTxt: label 'Reject the approval request for the record and create a notification.';
        CancelAllAppReqTxt: label 'Cancel the approval request for the record and create a notification.';
        PostDocumentTxt: label 'Post the sales or purchase document.';
        BackgroundDocumentPostTxt: label 'Post the sales or purchase document in the background.';
        BackgroundOCRReceiveIncomingDocTxt: label 'Receive the incoming document from OCR in the background.';
        BackgroundOCRSendIncomingDocTxt: label 'Send the incoming document to OCR in the background.';
        CheckCustomerCreditLimitTxt: label 'Check if the customer credit limit is exceeded.';
        CheckGeneralJournalBatchBalanceTxt: label 'Check if the general journal batch is balanced.';
        CreateApproveApprovalRequestAutomaticallyTxt: label 'Create and approve an approval request automatically.';
        SetStatusToPendingApprovalTxt: label 'Set document status to Pending Approval.';
        UserIDTok: label '<User>';
        TemplateTok: label '<Template>';
        GenJnlBatchTok: label '<Batch>';
        UnsupportedRecordTypeErr: label 'Record type %1 is not supported by this workflow response.', Comment='Record type Customer is not supported by this workflow response.';
        CreateOverdueNotifTxt: label 'Create notification for overdue approval requests.';
        ResponseAlreadyExistErr: label 'A response with description %1 already exists.';
        ApproverTypeTok: label '<Approver Type>';
        ApproverLimitTypeTok: label '<Approver Limit Type>';
        WorkflowUserGroupTok: label '<Workflow User Group Code>';
        ShowMessageTxt: label 'Show message "%1".', Comment='%1 = The message to be shown';
        ShowMessagePlaceholderMsg: label '%1', Locked=true;
        MessageTok: label '<Message>';
        RestrictRecordUsageTxt: label 'Add record restriction.';
        AllowRecordUsageTxt: label 'Remove record restriction.';
        RestrictUsageDetailsTxt: label 'The restriction was imposed by the %1 workflow, %2.', Comment='The restriction was imposed by the PIW workflow, Purchase Invoice Workflow.';
        MarkReadyForOCRTxt: label 'Mark the incoming document ready for OCR.';
        SendToOCRTxt: label 'Send the incoming document to OCR.';
        ReceiveFromOCRTxt: label 'Receive the incoming document from OCR.';
        CreateDocFromIncomingDocTxt: label 'Create a purchase document from an incoming document.';
        CreateReleasedDocFromIncomingDocTxt: label 'Create a released purchase document from an incoming document.';
        CreateJournalFromIncomingDocTxt: label 'Create journal line from incoming document.';
        RevertRecordValueTxt: label 'Revert the value of the %1 field on the record and save the change.', Comment='Revert the value of the Credit Limit (LCY) field on the record and save the change.';
        RevertRecordFieldValueTok: label '<Field>';
        ApplyNewValuesTxt: label 'Apply the new values.';
        DiscardNewValuesTxt: label 'Discard the new values.';


    procedure CreateResponsesLibrary()
    begin
        AddResponseToLibrary(DoNothingCode,0,DoNothingTxt,'GROUP 0');
        AddResponseToLibrary(CreateNotificationEntryCode,0,CreateNotifEntryTxt,'GROUP 3');
        AddResponseToLibrary(ReleaseDocumentCode,0,ReleaseDocumentTxt,'GROUP 0');
        AddResponseToLibrary(OpenDocumentCode,0,OpenDocumentTxt,'GROUP 0');
        AddResponseToLibrary(SetStatusToPendingApprovalCode,0,SetStatusToPendingApprovalTxt,'GROUP 0');
        AddResponseToLibrary(GetApprovalCommentCode,0,GetApprovalCommentTxt,'GROUP 0');
        AddResponseToLibrary(CreateApprovalRequestsCode,0,CreateApprovalRequestsTxt,'GROUP 5');
        AddResponseToLibrary(SendApprovalRequestForApprovalCode,0,SendApprReqForApprovalTxt,'GROUP 2');
        AddResponseToLibrary(ApproveAllApprovalRequestsCode,0,ApproveAllApprReqTxt,'GROUP 0');
        AddResponseToLibrary(RejectAllApprovalRequestsCode,0,RejectAllApprReqTxt,'GROUP 2');
        AddResponseToLibrary(CancelAllApprovalRequestsCode,0,CancelAllAppReqTxt,'GROUP 2');
        AddResponseToLibrary(PostDocumentCode,0,PostDocumentTxt,'GROUP 0');
        AddResponseToLibrary(PostDocumentAsyncCode,0,BackgroundDocumentPostTxt,'GROUP 0');

        AddResponseToLibrary(CreatePmtLineForPostedPurchaseDocAsyncCode,Database::"Purch. Inv. Header",CreatePmtLineAsyncTxt,'GROUP 1');
        AddResponseToLibrary(CreatePmtLineForPostedPurchaseDocCode,Database::"Purch. Inv. Header",CreatePmtLineTxt,'GROUP 1');

        AddResponseToLibrary(CreateOverdueNotificationCode,0,CreateOverdueNotifTxt,'GROUP 2');
        AddResponseToLibrary(CheckCustomerCreditLimitCode,0,CheckCustomerCreditLimitTxt,'GROUP 0');
        AddResponseToLibrary(CheckGeneralJournalBatchBalanceCode,0,CheckGeneralJournalBatchBalanceTxt,'GROUP 0');
        AddResponseToLibrary(CreateAndApproveApprovalRequestAutomaticallyCode,0,CreateApproveApprovalRequestAutomaticallyTxt,'GROUP 0');
        AddResponseToLibrary(ShowMessageCode,0,ShowMessageTxt,'GROUP 4');
        AddResponseToLibrary(RestrictRecordUsageCode,0,RestrictRecordUsageTxt,'GROUP 0');
        AddResponseToLibrary(AllowRecordUsageCode,0,AllowRecordUsageTxt,'GROUP 0');

        AddResponseToLibrary(GetMarkReadyForOCRCode,0,MarkReadyForOCRTxt,'GROUP 0');
        AddResponseToLibrary(GetSendToOCRCode,0,SendToOCRTxt,'GROUP 0');
        AddResponseToLibrary(GetReceiveFromOCRCode,0,ReceiveFromOCRTxt,'GROUP 0');
        AddResponseToLibrary(GetSendToOCRAsyncCode,0,BackgroundOCRSendIncomingDocTxt,'GROUP 0');
        AddResponseToLibrary(GetReceiveFromOCRAsyncCode,0,BackgroundOCRReceiveIncomingDocTxt,'GROUP 0');
        AddResponseToLibrary(GetSendToOCRCode,0,SendToOCRTxt,'GROUP 0');
        AddResponseToLibrary(GetCreateDocFromIncomingDocCode,0,CreateDocFromIncomingDocTxt,'GROUP 0');
        AddResponseToLibrary(GetCreateReleasedDocFromIncomingDocCode,0,CreateReleasedDocFromIncomingDocTxt,'GROUP 0');
        AddResponseToLibrary(GetCreateJournalFromIncomingDocCode,0,CreateJournalFromIncomingDocTxt,'GROUP 0');

        AddResponseToLibrary(RevertValueForFieldCode,0,RevertRecordValueTxt,'GROUP 6');
        AddResponseToLibrary(ApplyNewValuesCode,0,ApplyNewValuesTxt,'GROUP 7');
        AddResponseToLibrary(DiscardNewValuesCode,0,DiscardNewValuesTxt,'GROUP 0');

        OnAddWorkflowResponsesToLibrary;
    end;

    local procedure AddResponsePredecessors(ResponseFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case ResponseFunctionName of
          SetStatusToPendingApprovalCode:
            begin
              AddResponsePredecessor(SetStatusToPendingApprovalCode,WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode);
              AddResponsePredecessor(SetStatusToPendingApprovalCode,WorkflowEventHandling.RunWorkflowOnSendSpecialExamApprovalRequestCode);
              AddResponsePredecessor(SetStatusToPendingApprovalCode,WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode);
              AddResponsePredecessor(SetStatusToPendingApprovalCode,WorkflowEventHandling.RunWorkflowOnSendIncomingDocForApprovalCode);
              AddResponsePredecessor(
                SetStatusToPendingApprovalCode,WorkflowEventHandling.RunWorkflowOnCustomerCreditLimitNotExceededCode);
            end;
          CreateApprovalRequestsCode:
            begin
              AddResponsePredecessor(CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode);
              AddResponsePredecessor(CreateApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnSendSpecialExamApprovalRequestCode);
              AddResponsePredecessor(CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode);
              AddResponsePredecessor(CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnSendIncomingDocForApprovalCode);
              AddResponsePredecessor(CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode);
              AddResponsePredecessor(CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnCustomerChangedCode);
              AddResponsePredecessor(CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode);
              AddResponsePredecessor(CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnVendorChangedCode);
              AddResponsePredecessor(CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode);
              AddResponsePredecessor(CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnItemChangedCode);
              AddResponsePredecessor(
                CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode);
              AddResponsePredecessor(
                CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode);
              AddResponsePredecessor(CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnGeneralJournalBatchBalancedCode);
            end;
          SendApprovalRequestForApprovalCode:
            begin
              AddResponsePredecessor(
                SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode);
                      AddResponsePredecessor(
                SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnSendSpecialExamApprovalRequestCode);
              AddResponsePredecessor(SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode);
              AddResponsePredecessor(
                SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnSendIncomingDocForApprovalCode);
              AddResponsePredecessor(SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode);
              AddResponsePredecessor(SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnCustomerChangedCode);
              AddResponsePredecessor(SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode);
              AddResponsePredecessor(SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnVendorChangedCode);
              AddResponsePredecessor(SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode);
              AddResponsePredecessor(SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnItemChangedCode);
              AddResponsePredecessor(SendApprovalRequestForApprovalCode,
                WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode);
              AddResponsePredecessor(SendApprovalRequestForApprovalCode,
                WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode);
              AddResponsePredecessor(
                SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnGeneralJournalBatchBalancedCode);
              AddResponsePredecessor(SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
              AddResponsePredecessor(SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode);
            end;
          ReleaseDocumentCode:
            begin
              AddResponsePredecessor(ReleaseDocumentCode,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
              AddResponsePredecessor(ReleaseDocumentCode,WorkflowEventHandling.RunWorkflowOnCustomerCreditLimitNotExceededCode);
            end;
          RejectAllApprovalRequestsCode:
            AddResponsePredecessor(RejectAllApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode);
          OpenDocumentCode:
            begin
              AddResponsePredecessor(OpenDocumentCode,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode);
              AddResponsePredecessor(OpenDocumentCode,WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode);
              AddResponsePredecessor(OpenDocumentCode,WorkflowEventHandling.RunWorkflowOnCancelSpecialExamApprovalRequestCode);
              AddResponsePredecessor(OpenDocumentCode,WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode);
              AddResponsePredecessor(OpenDocumentCode,WorkflowEventHandling.RunWorkflowOnCancelIncomingDocApprovalRequestCode);
              AddResponsePredecessor(OpenDocumentCode,WorkflowEventHandling.RunWorkflowOnCancelCustomerApprovalRequestCode);
              AddResponsePredecessor(OpenDocumentCode,WorkflowEventHandling.RunWorkflowOnCancelVendorApprovalRequestCode);
              AddResponsePredecessor(OpenDocumentCode,WorkflowEventHandling.RunWorkflowOnCancelItemApprovalRequestCode);
              AddResponsePredecessor(OpenDocumentCode,WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode);
              AddResponsePredecessor(OpenDocumentCode,WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalBatchApprovalRequestCode);
            end;
          CancelAllApprovalRequestsCode:
            begin
              AddResponsePredecessor(CancelAllApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode);
              AddResponsePredecessor(CancelAllApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnCancelSpecialExamApprovalRequestCode);
              AddResponsePredecessor(CancelAllApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode);
              AddResponsePredecessor(
                CancelAllApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnCancelIncomingDocApprovalRequestCode);
              AddResponsePredecessor(CancelAllApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnCancelCustomerApprovalRequestCode);
              AddResponsePredecessor(CancelAllApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnCancelVendorApprovalRequestCode);
              AddResponsePredecessor(CancelAllApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnCancelItemApprovalRequestCode);
              AddResponsePredecessor(CancelAllApprovalRequestsCode,
                WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode);
              AddResponsePredecessor(CancelAllApprovalRequestsCode,
                WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalBatchApprovalRequestCode);
            end;
          RevertValueForFieldCode:
            begin
              AddResponsePredecessor(RevertValueForFieldCode,WorkflowEventHandling.RunWorkflowOnCustomerChangedCode);
              AddResponsePredecessor(RevertValueForFieldCode,WorkflowEventHandling.RunWorkflowOnVendorChangedCode);
              AddResponsePredecessor(RevertValueForFieldCode,WorkflowEventHandling.RunWorkflowOnItemChangedCode);
            end;
          ApplyNewValuesCode:
            AddResponsePredecessor(ApplyNewValuesCode,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
          DiscardNewValuesCode:
            AddResponsePredecessor(DiscardNewValuesCode,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode);
          GetMarkReadyForOCRCode:
            AddResponsePredecessor(GetMarkReadyForOCRCode,WorkflowEventHandling.RunWorkflowOnBinaryFileAttachedCode);
          CreateOverdueNotificationCode:
            AddResponsePredecessor(CreateOverdueNotificationCode,WorkflowEventHandling.RunWorkflowOnSendOverdueNotificationsCode);
          PostDocumentAsyncCode:
            AddResponsePredecessor(PostDocumentAsyncCode,WorkflowEventHandling.RunWorkflowOnAfterReleasePurchaseDocCode);
          PostDocumentCode:
            AddResponsePredecessor(PostDocumentCode,WorkflowEventHandling.RunWorkflowOnAfterReleasePurchaseDocCode);
          CreatePmtLineForPostedPurchaseDocAsyncCode:
            AddResponsePredecessor(
              CreatePmtLineForPostedPurchaseDocAsyncCode,WorkflowEventHandling.RunWorkflowOnAfterPostPurchaseDocCode);
          CreatePmtLineForPostedPurchaseDocCode:
            AddResponsePredecessor(CreatePmtLineForPostedPurchaseDocCode,WorkflowEventHandling.RunWorkflowOnAfterPostPurchaseDocCode);
          CheckGeneralJournalBatchBalanceCode:
            AddResponsePredecessor(CheckGeneralJournalBatchBalanceCode,
              WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode);
          CheckCustomerCreditLimitCode:
            AddResponsePredecessor(CheckCustomerCreditLimitCode,WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode);
          CreateAndApproveApprovalRequestAutomaticallyCode:
            AddResponsePredecessor(CreateAndApproveApprovalRequestAutomaticallyCode,
              WorkflowEventHandling.RunWorkflowOnCustomerCreditLimitNotExceededCode);
          GetReceiveFromOCRCode:
            AddResponsePredecessor(GetReceiveFromOCRCode,WorkflowEventHandling.RunWorkflowOnAfterSendToOCRIncomingDocCode);
          GetReceiveFromOCRAsyncCode:
            AddResponsePredecessor(GetReceiveFromOCRAsyncCode,WorkflowEventHandling.RunWorkflowOnAfterSendToOCRIncomingDocCode);
          GetSendToOCRCode:
            AddResponsePredecessor(GetSendToOCRCode,WorkflowEventHandling.RunWorkflowOnAfterReadyForOCRIncomingDocCode);
          GetSendToOCRAsyncCode:
            AddResponsePredecessor(GetSendToOCRAsyncCode,WorkflowEventHandling.RunWorkflowOnAfterReadyForOCRIncomingDocCode);
        end;
        OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAddWorkflowResponsesToLibrary()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    begin
    end;


    procedure ExecuteResponse(var Variant: Variant;ResponseWorkflowStepInstance: Record "Workflow Step Instance";xVariant: Variant)
    var
        WorkflowResponse: Record "Workflow Response";
        WorkflowChangeRecMgt: Codeunit "Workflow Change Rec Mgt.";
        ResponseExecuted: Boolean;
    begin
        if WorkflowResponse.Get(ResponseWorkflowStepInstance."Function Name") then
          case WorkflowResponse."Function Name" of
            DoNothingCode:
              DoNothing;
            CreateNotificationEntryCode:
              CreateNotificationEntry(Variant,ResponseWorkflowStepInstance);
            ReleaseDocumentCode:
              ReleaseDocument(Variant);
            OpenDocumentCode:
              OpenDocument(Variant);
            SetStatusToPendingApprovalCode:
              SetStatusToPendingApproval(Variant);
            GetApprovalCommentCode:
              GetApprovalComment(Variant);
            CreateApprovalRequestsCode:
              CreateApprovalRequests(Variant,ResponseWorkflowStepInstance);
            SendApprovalRequestForApprovalCode:
              SendApprovalRequestForApproval(Variant,ResponseWorkflowStepInstance);
            ApproveAllApprovalRequestsCode:
              ApproveAllApprovalRequests(Variant,ResponseWorkflowStepInstance);
            RejectAllApprovalRequestsCode:
              RejectAllApprovalRequests(Variant,ResponseWorkflowStepInstance);
            CancelAllApprovalRequestsCode:
              CancelAllApprovalRequests(Variant,ResponseWorkflowStepInstance);
            PostDocumentCode:
              PostDocument(Variant);
            PostDocumentAsyncCode:
              PostDocumentAsync(Variant);
            CreatePmtLineForPostedPurchaseDocAsyncCode:
              CreatePmtLineForPostedPurchaseDocAsync(ResponseWorkflowStepInstance);
            CreatePmtLineForPostedPurchaseDocCode:
              CreatePmtLineForPostedPurchaseDoc(ResponseWorkflowStepInstance);
            CreateOverdueNotificationCode:
              CreateOverdueNotifications(ResponseWorkflowStepInstance);
            CheckCustomerCreditLimitCode:
              CheckCustomerCreditLimit(Variant);
            CheckGeneralJournalBatchBalanceCode:
              CheckGeneralJournalBatchBalance(Variant);
            CreateAndApproveApprovalRequestAutomaticallyCode:
              CreateAndApproveApprovalRequestAutomatically(Variant,ResponseWorkflowStepInstance);
            ShowMessageCode:
              ShowMessage(ResponseWorkflowStepInstance);
            RestrictRecordUsageCode:
              RestrictRecordUsage(Variant,ResponseWorkflowStepInstance);
            AllowRecordUsageCode:
              AllowRecordUsage(Variant);
            GetMarkReadyForOCRCode:
              MarkReadyForOCR(Variant);
            GetSendToOCRCode:
              SendToOCR(Variant);
            GetSendToOCRAsyncCode:
              SendToOCRAsync(Variant);
            GetReceiveFromOCRCode:
              ReceiveFromOCR(Variant);
            GetReceiveFromOCRAsyncCode:
              ReceiveFromOCRAsync(Variant);
            GetCreateDocFromIncomingDocCode:
              CreateDocFromIncomingDoc(Variant);
            GetCreateReleasedDocFromIncomingDocCode:
              CreateReleasedDocFromIncomingDoc(Variant);
            GetCreateJournalFromIncomingDocCode:
              CreateJournalFromIncomingDoc(Variant);
            RevertValueForFieldCode:
              WorkflowChangeRecMgt.RevertValueForField(Variant,xVariant,ResponseWorkflowStepInstance);
            ApplyNewValuesCode:
              WorkflowChangeRecMgt.ApplyNewValues(Variant,ResponseWorkflowStepInstance);
            DiscardNewValuesCode:
              WorkflowChangeRecMgt.DiscardNewValues(Variant,ResponseWorkflowStepInstance);
            else begin
              OnExecuteWorkflowResponse(ResponseExecuted,Variant,xVariant,ResponseWorkflowStepInstance);
              if not ResponseExecuted then
                Error(NotSupportedResponseErr,WorkflowResponse."Function Name");
            end;
          end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnExecuteWorkflowResponse(var ResponseExecuted: Boolean;Variant: Variant;xVariant: Variant;ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    begin
    end;


    procedure DoNothingCode(): Code[128]
    begin
        exit(UpperCase('DoNothing'));
    end;


    procedure CreateNotificationEntryCode(): Code[128]
    begin
        exit(UpperCase('CreateNotificationEntry'));
    end;


    procedure ReleaseDocumentCode(): Code[128]
    begin
        exit(UpperCase('ReleaseDocument'));
    end;


    procedure OpenDocumentCode(): Code[128]
    begin
        exit(UpperCase('OpenDocument'));
    end;


    procedure SetStatusToPendingApprovalCode(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApproval'));
    end;


    procedure GetApprovalCommentCode(): Code[128]
    begin
        exit(UpperCase('GetApprovalComment'));
    end;


    procedure CreateApprovalRequestsCode(): Code[128]
    begin
        exit(UpperCase('CreateApprovalRequests'));
    end;


    procedure SendApprovalRequestForApprovalCode(): Code[128]
    begin
        exit(UpperCase('SendApprovalRequestForApproval'));
    end;


    procedure ApproveAllApprovalRequestsCode(): Code[128]
    begin
        exit(UpperCase('ApproveAllApprovalRequests'));
    end;


    procedure RejectAllApprovalRequestsCode(): Code[128]
    begin
        exit(UpperCase('RejectAllApprovalRequests'));
    end;


    procedure CancelAllApprovalRequestsCode(): Code[128]
    begin
        exit(UpperCase('CancelAllApprovalRequests'));
    end;


    procedure PostDocumentAsyncCode(): Code[128]
    begin
        exit(UpperCase('BackgroundPostApprovedPurchaseDoc'));
    end;


    procedure PostDocumentCode(): Code[128]
    begin
        exit(UpperCase('PostDocument'));
    end;


    procedure CreatePmtLineForPostedPurchaseDocAsyncCode(): Code[128]
    begin
        exit(UpperCase('BackgroundCreatePmtLineForPostedDocument'));
    end;


    procedure CreatePmtLineForPostedPurchaseDocCode(): Code[128]
    begin
        exit(UpperCase('CreatePmtLineForPostedDocument'));
    end;


    procedure CreateOverdueNotificationCode(): Code[128]
    begin
        exit(UpperCase('CreateOverdueNotifications'));
    end;


    procedure CheckCustomerCreditLimitCode(): Code[128]
    begin
        exit(UpperCase('CheckCustomerCreditLimit'));
    end;


    procedure CheckGeneralJournalBatchBalanceCode(): Code[128]
    begin
        exit(UpperCase('CheckGeneralJournalBatchBalance'));
    end;


    procedure CreateAndApproveApprovalRequestAutomaticallyCode(): Code[128]
    begin
        exit(UpperCase('CreateAndApproveApprovalRequestAutomatically'));
    end;


    procedure ShowMessageCode(): Code[128]
    begin
        exit(UpperCase('ShowMessage'));
    end;


    procedure RestrictRecordUsageCode(): Code[128]
    begin
        exit(UpperCase('RestrictRecordUsage'));
    end;


    procedure AllowRecordUsageCode(): Code[128]
    begin
        exit(UpperCase('AllowRecordUsage'));
    end;


    procedure GetMarkReadyForOCRCode(): Code[128]
    begin
        exit(UpperCase('MarkReadyForOCR'));
    end;


    procedure GetSendToOCRAsyncCode(): Code[128]
    begin
        exit(UpperCase('BackgroundSendToOCR'));
    end;


    procedure GetSendToOCRCode(): Code[128]
    begin
        exit(UpperCase('SendToOCR'));
    end;


    procedure GetReceiveFromOCRAsyncCode(): Code[128]
    begin
        exit(UpperCase('BackgroundReceiveFromOCR'));
    end;


    procedure GetReceiveFromOCRCode(): Code[128]
    begin
        exit(UpperCase('ReceiveFromOCR'));
    end;


    procedure GetCreateDocFromIncomingDocCode(): Code[128]
    begin
        exit(UpperCase('CreateDocFromIncomingDoc'));
    end;


    procedure GetCreateReleasedDocFromIncomingDocCode(): Code[128]
    begin
        exit(UpperCase('CreateReleasedDocFromIncomingDoc'));
    end;


    procedure GetCreateJournalFromIncomingDocCode(): Code[128]
    begin
        exit(UpperCase('CreateJournalFromIncomingDoc'));
    end;


    procedure RevertValueForFieldCode(): Code[128]
    begin
        exit(UpperCase('RevertValueForField'));
    end;


    procedure ApplyNewValuesCode(): Code[128]
    begin
        exit(UpperCase('ApplyNewValues'));
    end;


    procedure DiscardNewValuesCode(): Code[128]
    begin
        exit(UpperCase('DiscardNewValues'));
    end;

    local procedure DoNothing()
    begin
    end;

    local procedure CreateNotificationEntry(Variant: Variant;WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        NotificationEntry: Record "Notification Entry";
    begin
        if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then
          NotificationEntry.CreateNew(NotificationEntry.Type::"New Record",
            WorkflowStepArgument."Notification User ID",Variant,WorkflowStepArgument."Link Target Page",
            WorkflowStepArgument."Custom Link");
    end;

    local procedure ReleaseDocument(var Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        ReleaseIncomingDocument: Codeunit "Release Incoming Document";
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        SpecialExam: Record UnknownRecord78002;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Approval Entry":
            begin
              ApprovalEntry := Variant;
              TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
              Variant := TargetRecRef;
              ReleaseDocument(Variant);
            end;
          Database::"Purchase Header":
            ReleasePurchaseDocument.PerformManualRelease(Variant);
          Database::"Sales Header":
            ReleaseSalesDocument.PerformManualRelease(Variant);
          Database::"Incoming Document":
            ReleaseIncomingDocument.PerformManualRelease(Variant);
          Database::"Aca-Special Exams Details":
            begin
              ReleasePurchaseDocument.ReleaseSpecialExams(Variant);
            end;
          else
            Error(UnsupportedRecordTypeErr,RecRef.Caption);
        end;
    end;

    local procedure OpenDocument(var Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        ReleaseIncomingDocument: Codeunit "Release Incoming Document";
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Approval Entry":
            begin
              ApprovalEntry := Variant;
              TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
              Variant := TargetRecRef;
              OpenDocument(Variant);
            end;
          Database::"Purchase Header":
            ReleasePurchaseDocument.Reopen(Variant);
          Database::"Sales Header":
            ReleaseSalesDocument.Reopen(Variant);
          Database::"Incoming Document":
            ReleaseIncomingDocument.Reopen(Variant);
          Database::"Aca-Special Exams Details":
            begin
              ReleasePurchaseDocument.ReOPenSpecialExams(Variant);
            end;
          else
            Error(UnsupportedRecordTypeErr,RecRef.Caption);
        end;
    end;


    procedure SetStatusToPendingApproval(var Variant: Variant)
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        ApprovalsMgmt.SetStatusToPendingApproval(Variant);
    end;

    local procedure GetApprovalComment(Variant: Variant)
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        ApprovalsMgmt.GetApprovalComment(Variant);
    end;

    local procedure CreateApprovalRequests(Variant: Variant;WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        ApprovalsMgmt.CreateApprovalRequests(RecRef,WorkflowStepInstance);
    end;

    local procedure BuildTheCreateApprovalReqDescription(WorkflowResponse: Record "Workflow Response";WorkflowStepArgument: Record "Workflow Step Argument"): Text[250]
    var
        ApproverLimitDesc: Text;
        WorkflowUserGroupDesc: Text;
    begin
        ApproverLimitDesc := StrSubstNo(CreateApprovalApprovalLimitTxt,
            GetTokenValue(ApproverLimitTypeTok,Format(WorkflowStepArgument."Approver Limit Type")));
        WorkflowUserGroupDesc := StrSubstNo(CreateApprovalWorkflowGroupTxt,
            GetTokenValue(WorkflowUserGroupTok,Format(WorkflowStepArgument."Workflow User Group Code")));

        if GetTokenValue(ApproverTypeTok,Format(WorkflowStepArgument."Approver Type")) = ApproverTypeTok then
          exit(CopyStr(StrSubstNo(WorkflowResponse.Description,ApproverTypeTok,
                StrSubstNo('%1/%2',ApproverLimitDesc,WorkflowUserGroupDesc)),1,250));

        if WorkflowStepArgument."Approver Type" <> WorkflowStepArgument."approver type"::"Workflow User Group" then
          exit(CopyStr(StrSubstNo(WorkflowResponse.Description,
                GetTokenValue(ApproverTypeTok,Format(WorkflowStepArgument."Approver Type")),
                ApproverLimitDesc),1,250));

        exit(CopyStr(StrSubstNo(WorkflowResponse.Description,
              GetTokenValue(ApproverTypeTok,Format(WorkflowStepArgument."Approver Type")),
              WorkflowUserGroupDesc),1,250));
    end;

    local procedure SendApprovalRequestForApproval(Variant: Variant;WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Approval Entry":
            ApprovalsMgmt.SendApprovalRequestFromApprovalEntry(Variant,WorkflowStepInstance);
          else
            ApprovalsMgmt.SendApprovalRequestFromRecord(RecRef,WorkflowStepInstance);
        end;
    end;

    local procedure ApproveAllApprovalRequests(Variant: Variant;WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Approval Entry":
            begin
              ApprovalEntry := Variant;
              RecRef.Get(ApprovalEntry."Record ID to Approve");
              ApproveAllApprovalRequests(RecRef,WorkflowStepInstance);
            end;
          else
            ApprovalsMgmt.ApproveApprovalRequestsForRecord(RecRef,WorkflowStepInstance);
        end;
    end;

    local procedure RejectAllApprovalRequests(Variant: Variant;WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Approval Entry":
            begin
              ApprovalEntry := Variant;
              RecRef.Get(ApprovalEntry."Record ID to Approve");
              RejectAllApprovalRequests(RecRef,WorkflowStepInstance);
            end;
          else
            ApprovalsMgmt.RejectApprovalRequestsForRecord(RecRef,WorkflowStepInstance);
        end;
    end;

    local procedure CancelAllApprovalRequests(Variant: Variant;WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Approval Entry":
            begin
              ApprovalEntry := Variant;
              RecRef.Get(ApprovalEntry."Record ID to Approve");
              CancelAllApprovalRequests(RecRef,WorkflowStepInstance);
            end;
          else
            ApprovalsMgmt.CancelApprovalRequestsForRecord(RecRef,WorkflowStepInstance);
        end;
    end;

    local procedure PostDocumentAsync(Variant: Variant)
    var
        JobQueueEntry: Record "Job Queue Entry";
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Purchase Header":
            begin
              PurchaseHeader := Variant;
              PurchaseHeader.TestField(Status,PurchaseHeader.Status::Released);
              JobQueueEntry.ScheduleJobQueueEntry(Codeunit::"Purchase Post via Job Queue",PurchaseHeader.RecordId);
            end;
          Database::"Sales Header":
            begin
              SalesHeader := Variant;
              SalesHeader.TestField(Status,SalesHeader.Status::Released);
              JobQueueEntry.ScheduleJobQueueEntry(Codeunit::"Sales Post via Job Queue",SalesHeader.RecordId);
            end;
          else
            Error(UnsupportedRecordTypeErr,RecRef.Caption);
        end;
    end;

    local procedure PostDocument(Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Purchase Header":
            Codeunit.Run(Codeunit::"Purch.-Post",Variant);
          Database::"Sales Header":
            Codeunit.Run(Codeunit::"Sales-Post",Variant);
          else
            Error(UnsupportedRecordTypeErr,RecRef.Caption);
        end;
    end;

    local procedure CreatePmtLineForPostedPurchaseDocAsync(WorkflowStepInstance: Record "Workflow Step Instance")
    var
        JobQueueEntry: Record "Job Queue Entry";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then
          JobQueueEntry.ScheduleJobQueueEntry(Codeunit::"Workflow Create Payment Line",WorkflowStepArgument.RecordId);
    end;

    local procedure CreatePmtLineForPostedPurchaseDoc(WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowCreatePaymentLine: Codeunit "Workflow Create Payment Line";
    begin
        if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then
          WorkflowCreatePaymentLine.CreatePmtLine(WorkflowStepArgument);
    end;

    local procedure CheckCustomerCreditLimit(Variant: Variant)
    var
        SalesHeader: Record "Sales Header";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Sales Header":
            begin
              SalesHeader := Variant;
              SalesHeader.CheckAvailableCreditLimit;
            end;
        end;
    end;

    local procedure CheckGeneralJournalBatchBalance(Variant: Variant)
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Gen. Journal Batch":
            begin
              GenJournalBatch := Variant;
              GenJournalBatch.CheckBalance;
            end;
        end;
    end;

    local procedure CreateAndApproveApprovalRequestAutomatically(Variant: Variant;WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Sales Header":
            ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef,WorkflowStepInstance);
          Database::Customer:
            ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef,WorkflowStepInstance);
        end;
    end;

    local procedure ShowMessage(WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        WorkflowStepArgument.Get(WorkflowStepInstance.Argument);
        Message(StrSubstNo(ShowMessagePlaceholderMsg,WorkflowStepArgument.Message));
    end;

    local procedure RestrictRecordUsage(Variant: Variant;WorkflowStepInstance: Record "Workflow Step Instance")
    var
        Workflow: Record Workflow;
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        Workflow.Get(WorkflowStepInstance."Workflow Code");
        RecordRestrictionMgt.RestrictRecordUsage(RecRef.RecordId,StrSubstNo(RestrictUsageDetailsTxt,Workflow.Code,Workflow.Description));
    end;

    local procedure AllowRecordUsage(Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry";
        GenJournalBatch: Record "Gen. Journal Batch";
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
          Database::"Approval Entry":
            begin
              RecordRestrictionMgt.AllowRecordUsage(RecRef.RecordId);
              RecRef.SetTable(ApprovalEntry);
              RecRef.Get(ApprovalEntry."Record ID to Approve");
              AllowRecordUsage(RecRef);
            end;
          Database::"Gen. Journal Batch":
            begin
              RecRef.SetTable(GenJournalBatch);
              RecordRestrictionMgt.AllowGenJournalBatchUsage(GenJournalBatch);
            end
          else
            RecordRestrictionMgt.AllowRecordUsage(RecRef.RecordId);
        end;
    end;


    procedure AddResponseToLibrary(FunctionName: Code[128];TableID: Integer;Description: Text[250];ResponseOptionGroup: Code[20])
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        if WorkflowResponse.Get(FunctionName) then
          exit;

        WorkflowResponse.SetRange(Description,Description);
        if not WorkflowResponse.IsEmpty then
          Error(ResponseAlreadyExistErr,Description);

        WorkflowResponse.Init;
        WorkflowResponse."Function Name" := FunctionName;
        WorkflowResponse."Table ID" := TableID;
        WorkflowResponse.Description := Description;
        WorkflowResponse."Response Option Group" := ResponseOptionGroup;
        WorkflowResponse.Insert;

        AddResponsePredecessors(WorkflowResponse."Function Name");
    end;


    procedure AddResponsePredecessor(FunctionName: Code[128];PredecessorFunctionName: Code[128])
    var
        WFEventResponseCombination: Record "WF Event/Response Combination";
    begin
        WFEventResponseCombination.Init;
        WFEventResponseCombination.Type := WFEventResponseCombination.Type::Response;
        WFEventResponseCombination."Function Name" := FunctionName;
        WFEventResponseCombination."Predecessor Type" := WFEventResponseCombination."predecessor type"::"Event";
        WFEventResponseCombination."Predecessor Function Name" := PredecessorFunctionName;
        if WFEventResponseCombination.Insert then;
    end;


    procedure GetDescription(WorkflowStepArgument: Record "Workflow Step Argument"): Text[250]
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        if not WorkflowResponse.Get(WorkflowStepArgument."Response Function Name") then
          exit('');
        case WorkflowResponse."Function Name" of
          CreateNotificationEntryCode:
            exit(CopyStr(StrSubstNo(WorkflowResponse.Description,
                  GetTokenValue(UserIDTok,WorkflowStepArgument."Notification User ID")),1,250));
          ShowMessageCode:
            exit(CopyStr(StrSubstNo(WorkflowResponse.Description,
                  GetTokenValue(MessageTok,WorkflowStepArgument.Message)),1,250));
          CreatePmtLineForPostedPurchaseDocAsyncCode,
          CreatePmtLineForPostedPurchaseDocCode:
            exit(CopyStr(StrSubstNo(WorkflowResponse.Description,
                  GetTokenValue(TemplateTok,WorkflowStepArgument."General Journal Template Name"),
                  GetTokenValue(GenJnlBatchTok,WorkflowStepArgument."General Journal Batch Name")),1,250));
          CreateApprovalRequestsCode:
            exit(BuildTheCreateApprovalReqDescription(WorkflowResponse,WorkflowStepArgument));
          SendApprovalRequestForApprovalCode,
          RejectAllApprovalRequestsCode,
          CancelAllApprovalRequestsCode,
          CreateOverdueNotificationCode:
            exit(CopyStr(StrSubstNo(WorkflowResponse.Description),1,250));
          RevertValueForFieldCode:
            begin
              WorkflowStepArgument.CalcFields("Field Caption");
              exit(CopyStr(StrSubstNo(WorkflowResponse.Description,
                    GetTokenValue(RevertRecordFieldValueTok,WorkflowStepArgument."Field Caption")),1,250));
            end;
          else
            exit(WorkflowResponse.Description);
        end;
    end;

    local procedure GetTokenValue(TokenValue: Text;FieldValue: Text): Text
    begin
        if FieldValue <> '' then
          exit(FieldValue);

        exit(TokenValue);
    end;


    procedure IsArgumentMandatory(ResponseFunctionName: Code[128]): Boolean
    begin
        if ResponseFunctionName in
           [CreateNotificationEntryCode,CreatePmtLineForPostedPurchaseDocAsyncCode,CreateApprovalRequestsCode,
            CreatePmtLineForPostedPurchaseDocCode]
        then
          exit(true);

        exit(false);
    end;


    procedure HasRequiredArguments(WorkflowStep: Record "Workflow Step"): Boolean
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        if not IsArgumentMandatory(WorkflowStep."Function Name") then
          exit(true);

        if not WorkflowStepArgument.Get(WorkflowStep.Argument) then
          exit(false);

        case WorkflowStep."Function Name" of
          CreatePmtLineForPostedPurchaseDocAsyncCode,
          CreatePmtLineForPostedPurchaseDocCode:
            if (WorkflowStepArgument."General Journal Template Name" = '') or
               (WorkflowStepArgument."General Journal Batch Name" = '')
            then
              exit(false);
          CreateApprovalRequestsCode:
            case WorkflowStepArgument."Approver Type" of
              WorkflowStepArgument."approver type"::"Workflow User Group":
                begin
                  if WorkflowStepArgument."Workflow User Group Code" = '' then
                    exit(false);
                end;
              else begin
                if WorkflowStepArgument."Approver Limit Type" = WorkflowStepArgument."approver limit type"::"Specific Approver" then
                  if WorkflowStepArgument."Approver User ID" = '' then
                    exit(false);
              end;
            end;
          CreateNotificationEntryCode:
            if WorkflowStepArgument."Notification User ID" = '' then
              exit(false);
        end;

        exit(true);
    end;

    local procedure CreateOverdueNotifications(WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        NotificationManagement: Codeunit "Notification Management";
    begin
        if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then
          NotificationManagement.CreateOverdueNotifications(WorkflowStepArgument);
    end;

    local procedure MarkReadyForOCR(Variant: Variant)
    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocumentAttachment := Variant;
        IncomingDocument.Get(IncomingDocumentAttachment."Incoming Document Entry No.");
        IncomingDocument.SendToJobQueue(false);
    end;

    local procedure SendToOCRAsync(Variant: Variant)
    var
        JobQueueEntry: Record "Job Queue Entry";
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument := Variant;
        IncomingDocument.TestField(Status,IncomingDocument.Status::Released);
        IncomingDocument.TestField("OCR Status",IncomingDocument."ocr status"::Ready);
        JobQueueEntry.ScheduleJobQueueEntry(Codeunit::"OCR Inc. Doc. via Job Queue",IncomingDocument.RecordId);
    end;

    local procedure SendToOCR(Variant: Variant)
    var
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument := Variant;
        IncomingDocument.SendToOCR(false);
    end;

    local procedure ReceiveFromOCRAsync(Variant: Variant)
    var
        IncomingDocument: Record "Incoming Document";
        OCRIncDocViaJobQueue: Codeunit "OCR Inc. Doc. via Job Queue";
    begin
        IncomingDocument := Variant;
        IncomingDocument.TestField(Status,IncomingDocument.Status::Released);
        IncomingDocument.TestField("OCR Status",IncomingDocument."ocr status"::Sent);
        OCRIncDocViaJobQueue.EnqueueIncomingDoc(IncomingDocument);
    end;

    local procedure ReceiveFromOCR(Variant: Variant)
    var
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument := Variant;
        IncomingDocument.RetrieveFromOCR(false);
    end;

    local procedure CreateDocFromIncomingDoc(Variant: Variant)
    var
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument := Variant;
        IncomingDocument.TryCreateDocumentWithDataExchange;
    end;

    local procedure CreateReleasedDocFromIncomingDoc(Variant: Variant)
    var
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument := Variant;
        IncomingDocument.CreateReleasedDocumentWithDataExchange;
    end;

    local procedure CreateJournalFromIncomingDoc(Variant: Variant)
    var
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument := Variant;
        IncomingDocument.TryCreateGeneralJournalLineWithDataExchange;
    end;
}

