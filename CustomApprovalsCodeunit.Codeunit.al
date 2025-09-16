#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60277 "Custom Approvals Codeunit"
{

    trigger OnRun()
    begin
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        UnsupportedRecordTypeErr: label 'Record type %1 is not supported by this workflow response.', Comment='Record type Customer is not supported by this workflow response.';
        NoWorkflowEnabledErr: label 'This record is not supported by related approval workflow.';
        OnSendPaymentApprovalRequestTxt: label 'Approval of a Payment is requested';
        RunWorkflowOnSendPaymentForApprovalCode: label 'RUNWORKFLOWONSENDPAYMENTFORAPPROVAL';
        OnCancelPaymentApprovalRequestTxt: label 'An Approval of a Payment is canceled';
        RunWorkflowOnCancelPaymentForApprovalCode: label 'RUNWORKFLOWONCANCELPAYMENTFORAPPROVAL';
        OnSendInterbankApprovalRequestTxt: label 'Approval of a Interbank is requested';
        RunWorkflowOnSendInterbankForApprovalCode: label 'RUNWORKFLOWONSENDINTERBANKFORAPPROVAL';
        OnCancelInterbankApprovalRequestTxt: label 'An Approval of a Interbank is canceled';
        RunWorkflowOnCancelInterbankForApprovalCode: label 'RUNWORKFLOWONCANCELINTERBANKFORAPPROVAL';
        OnSendStaffClaimApprovalRequestTxt: label 'Approval of a Staff Claim is requested';
        RunWorkflowOnSendStaffClaimForApprovalCode: label 'RUNWORKFLOWONSENDSTAFFCLAIMFORAPPROVAL';
        OnCancelStaffClaimApprovalRequestTxt: label 'An Approval of a Staff Claim is canceled';
        RunWorkflowOnCancelStaffClaimForApprovalCode: label 'RUNWORKFLOWONCANCELSTAFFCLAIMFORAPPROVAL';
        OnSendStaffAdvanceApprovalRequestTxt: label 'Approval of a Staff Advance is requested';
        RunWorkflowOnSendStaffAdvanceForApprovalCode: label 'RUNWORKFLOWONSENDSTAFFADVANCEFORAPPROVAL';
        OnCancelStaffAdvanceApprovalRequestTxt: label 'An Approval of a Staff Advance is canceled';
        RunWorkflowOnCancelStaffAdvanceForApprovalCode: label 'RUNWORKFLOWONCANCELSTAFFADVANCEFORAPPROVAL';
        OnSendStaffAdvanceSurrenderApprovalRequestTxt: label 'Approval of a Staff Advance Surrender is requested';
        RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode: label 'RUNWORKFLOWONSENDSTAFFADVANCESURRENDERFORAPPROVAL';
        OnCancelStaffAdvanceSurrenderApprovalRequestTxt: label 'An Approval of a Staff Advance Surrender is canceled';
        RunWorkflowOnCancelStaffAdvanceSurrenderForApprovalCode: label 'RUNWORKFLOWONCANCELSTAFFADVANCESURRENDERFORAPPROVAL';
        OnSendStoreRequisitionApprovalRequestTxt: label 'Approval of a Store Requisition is requested';
        RunWorkflowOnSendStoreRequisitionForApprovalCode: label 'RUNWORKFLOWONSENDSTOREREQUISITIONFORAPPROVAL';
        OnCancelStoreRequisitionApprovalRequestTxt: label 'An Approval of a Store Requisition is canceled';
        RunWorkflowOnCancelStoreRequisitionForApprovalCode: label 'RUNWORKFLOWONCANCELSTOREREQUISITIONFORAPPROVAL';
        OnSendImprestApprovalRequestTxt: label 'Approval of a Imprest is requested';
        RunWorkflowOnSendImprestForApprovalCode: label 'RUNWORKFLOWONSENDIMPRESTFORAPPROVAL';
        OnCancelImprestApprovalRequestTxt: label 'An Approval of a Imprest is canceled';
        RunWorkflowOnCancelImprestForApprovalCode: label 'RUNWORKFLOWONCANCELIMPRESTFORAPPROVAL';
        OnSendImprestSurrenderApprovalRequestTxt: label 'Approval of a Imprest Surrender is requested';
        RunWorkflowOnSendImprestSurrenderForApprovalCode: label 'RUNWORKFLOWONSENDIMPRESTSURRENDERFORAPPROVAL';
        OnCancelImprestSurrenderApprovalRequestTxt: label 'An Approval of a Imprest Surrender is canceled';
        RunWorkflowOnCancelImprestSurrenderForApprovalCode: label 'RUNWORKFLOWONCANCELIMPRESTSURRENDERFORAPPROVAL';
        OnSendOvertimeApprovalRequestTxt: label 'Approval of a Overtime is requested';
        RunWorkflowOnSendOvertimeForApprovalCode: label 'RUNWORKFLOWONSENDOVERTIMEFORAPPROVAL';
        OnCancelOvertimeApprovalRequestTxt: label 'An Approval of a Overtime is canceled';
        RunWorkflowOnCancelOvertimeForApprovalCode: label 'RUNWORKFLOWONCANCELOVERTIMEFORAPPROVAL';
        OnSendBudgetApprovalRequestTxt: label 'Approval of a Budget is requested';
        RunWorkflowOnSendBudgetForApprovalCode: label 'RUNWORKFLOWONSENDBUDGETFORAPPROVAL';
        OnCancelBudgetApprovalRequestTxt: label 'An Approval of a Budget is canceled';
        RunWorkflowOnCancelBudgetForApprovalCode: label 'RUNWORKFLOWONCANCELBUDGETFORAPPROVAL';
        OnSendVoteApprovalRequestTxt: label 'Approval of a Vote Transfer is requested';
        RunWorkflowOnSendVoteForApprovalCode: label 'RUNWORKFLOWONSENDVOTEFORAPPROVAL';
        OnCancelVoteApprovalRequestTxt: label 'An Approval of a Vote is canceled';
        RunWorkflowOnCancelVoteForApprovalCode: label 'RUNWORKFLOWONCANCELVOTEFORAPPROVAL';
        OnSendWorkplanApprovalRequestTxt: label 'Approval of a Workplan is requested';
        RunWorkflowOnSendWorkplanForApprovalCode: label 'RUNWORKFLOWONSENDWORKPLANFORAPPROVAL';
        OnCancelWorkplanApprovalRequestTxt: label 'An Approval of a Workplan is canceled';
        RunWorkflowOnCancelWorkplanForApprovalCode: label 'RUNWORKFLOWONCANCELWORKPLANFORAPPROVAL';
        OnSendAssetTransferApprovalRequestTxt: label 'An Approval of an Asset Transfer is requested';
        RunWorkflowOnSendAssetTransferForApprovalCode: label 'RUNWORKFLOWONSENDASSETTRANSFERFORAPPROVAL';
        OnCancelAssetTransferApprovalRequestTxt: label 'An Approval of an Asset Transfer is canceled';
        RunWorkflowOnCancelAssetTransferForApprovalCode: label 'RUNWORKFLOWONCANCELASSETTRANSFERFORAPPROVAL';
        "**CoreTec Hr**": ;
        OnSendHrJobsApprovalRequestTxt: label 'An Approval Request for a Job Position has been requested.';
        RunWorkflowOnSendHrJobsForApprovalCode: label 'RUNWORKFLOWONSENDHRJOBSFORAPPROVAL';
        OnCancelHrJobsApprovalRequestTxt: label 'An Approval Request for a Job Position has been cancelled.';
        RunWorkflowOnCancelHrJobsForApprovalCode: label 'RUNWORKFLOWONCANCELHRJOBSFORAPPROVAL';
        OnSendHrEmployeeReqApprovalRequestTxt: label 'An Approval request for Employee Requsition is Requested.';
        RunWorkflowOnSendHrEmployeeReqForApprovalCode: label 'RUNWORKFLOWONSENDHREMPLOYEEREQFORAPPROVAL';
        OnCancelHrEmployeeReqApprovalRequestTxt: label 'An Approval request for Employee Requsition is Cancelled';
        RunWorkflowOnCancelHrEmployeeReqForApprovalCode: label 'RUNWORKFLOWONCANCELHREMPLOYEEREQFORAPPROVAL';
        OnSendHrLeaveApprovalRequestTxt: label 'An Approval Request for Leave application has been Requested.';
        RunWorkflowOnSendHrLeaveForApprovalCode: label 'RUNWORKFLOWONSENDHRLEAVEFORAPPROVAL';
        OnCancelHrLeaveApprovalRequestTxt: label 'An Approval Request for Leave Application has been Cancelled';
        RunWorkflowOnCancelHrLeaveForApprovalCode: label 'RUNWORKFLOWONCANCELHRLEAVEFORAPPROVAL';
        OnSendHrTrainingApprovalRequestTxt: label 'An Approval Request for Training application has been Requested.';
        RunWorkflowOnSendHrTrainingForApprovalCode: label 'RUNWORKFLOWONSENDHRTRAININGFORAPPROVAL';
        OnCancelHrTrainingApprovalRequestTxt: label 'An Approval Request for Training Application has been Cancelled';
        RunWorkflowOnCancelHrTrainingForApprovalCode: label 'RUNWORKFLOWONCANCELHRTRAININGFORAPPROVAL';
        OnSendHrTransportApprovalRequestTxt: label 'An Approval Request for Transport Requisition has been Requested.';
        RunWorkflowOnSendHrTransportForApprovalCode: label 'RUNWORKFLOWONSENDHRTRANSPORTFORAPPROVAL';
        OnCancelHrTransportApprovalRequestTxt: label 'An Approval Request for Transport Requisition has been Cancelled';
        RunWorkflowOnCancelHrTransportForApprovalCode: label 'RUNWORKFLOWONCANCELHRTRANSPORTFORAPPROVAL';
        OnSendHrEmpTransApprovalRequestTxt: label 'An Approval Request for Employee Transfer has been Requested.';
        RunWorkflowOnSendHrEmpTransForApprovalCode: label 'RUNWORKFLOWONSENDHREMPTRANSFORAPPROVAL';
        OnCancelHrEmpTransApprovalRequestTxt: label 'An Approval Request for Employee Transfer has been Cancelled.';
        RunWorkflowOnCancelHrEmpTransForApprovalCode: label 'RUNWORKFLOWONCANCELHREMPTRANSFORAPPROVAL';
        OnSendHrPromotionApprovalRequestTxt: label 'An Approval Request for Employee Promotion has been requested.';
        RunWorkflowOnSendHrPromotionForApprovalCode: label 'RUNWORKFLOWONSENDHRPROMOTIONFORAPPROVAL';
        OnCancelHrPromotionApprovalRequestTxt: label 'An Approval Request for Employee Promotion has been cancelled.';
        RunWorkflowOnCancelHrPromotionForApprovalCode: label 'RUNWORKFLOWONCANCELHRPROMOTIONFORAPPROVAL';
        OnSendHrConfirmationApprovalRequestTxt: label 'An Approval Request for Employee Confirmation has been requested.';
        RunWorkflowOnSendHrConfirmationForApprovalCode: label 'RUNWORKFLOWONSENDHRCONFIRMATIONFORAPPROVAL';
        OnCancelHrConfirmationApprovalRequestTxt: label 'Approval Request for Employee Confirmation has been cancelled.';
        RunWorkflowOnCancelHrConfirmationForApprovalCode: label 'RUNWORKFLOWONCANCELHRCONFIRMATIONFORAPPROVAL';
        "**********Employee": ;
        EmployeeSendForApprovalEventDescTxt: label 'An Approval Request for the Employee has been requested.';
        EmployeeApprovalRequestCancelEventDescTxt: label 'An Approval Request for the Employee has been Cancelled.';
        EmployeeChangedTxt: label 'A Employee record is changed.';
        "***Investment*****": ;
        OnSendInvestimentApprovalRequestTxt: label 'An Approval Request for Investiment application has been Requested.';
        RunWorkflowOnSendInvestimentForApprovalCode: label 'RUNWORKFLOWONSENDINVESTIMENTFORAPPROVAL';
        OnCancelInvestimentApprovalRequestTxt: label 'An Approval Request for Investiment Application has been Cancelled';
        RunWorkflowOnCancelInvestimentForApprovalCode: label 'RUNWORKFLOWONCANCELINVESTIMENTFORAPPROVAL';
        "*********Academics*****": ;
        OnSendApplicationFormApprovalRequestTxt: label 'An Approval Request for Application Form has been Requested.';
        RunWorkflowOnSendApplicationFormForApprovalCode: label 'RUNWORKFLOWONSENDAPPLICATION FORM FORAPPROVAL';
        OnCancelApplicationFormApprovalRequestTxt: label 'An Approval Request for Application Form has been Cancelled';
        RunWorkflowOnCancelApplicationFormForApprovalCode: label 'RUNWORKFLOWONCANCELAPPLICATION FORM FORAPPROVAL';
        "*****End Academics*******": ;


    procedure CheckApprovalsWorkflowEnabled(var Variant: Variant): Boolean
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
          Database::"FIN-Payments Header":
            exit(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendPaymentForApprovalCode));
          Database::"FIN-InterBank Transfers":
            exit(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendInterbankForApprovalCode));
          Database::"FIN-Staff Claims Header":
            exit(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendStaffClaimForApprovalCode));
          Database::"FIN-Staff Advance Header":
            exit(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendStaffAdvanceForApprovalCode));
          Database::"FIN-Staff Advance Surr. Header":
            exit(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode));
          Database::"FIN-Imprest Header":
            exit(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendImprestForApprovalCode));
          Database::"FIN-Imprest Surr. Header":
            exit(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendImprestSurrenderForApprovalCode));
         Database::"PROC-Store Requistion Header":
            exit(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendStoreRequisitionForApprovalCode));
          Database::"G/L Budget Name":
            exit(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendBudgetForApprovalCode));

          Database::"Bank Account":
            exit(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendInvestimentForApprovalCode));
          //HR
          //Leave

          Database::"HRM-Leave Requisition":
          exit(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendHrLeaveForApprovalCode));


          else
            Error(UnsupportedRecordTypeErr,RecRef.Caption);
        end;
    end;


    procedure CheckApprovalsWorkflowEnabledCode(var Variant: Variant;CheckApprovalsWorkflowTxt: Text): Boolean
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        begin
          if not WorkflowManagement.CanExecuteWorkflow(Variant,CheckApprovalsWorkflowTxt) then
          Error(NoWorkflowEnabledErr);
          exit(true);
        end;
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendDocForApproval(var Variant: Variant)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelDocApprovalRequest(var Variant: Variant)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddWorkflowEventsToLibrary()
    var
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendPaymentForApprovalCode,Database::"FIN-Payments Header",OnSendPaymentApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelPaymentForApprovalCode,Database::"FIN-Payments Header",OnCancelPaymentApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendInterbankForApprovalCode,Database::"FIN-InterBank Transfers",OnSendInterbankApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelInterbankForApprovalCode,Database::"FIN-InterBank Transfers",OnCancelInterbankApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffClaimForApprovalCode,Database::"FIN-Staff Claims Header",OnSendStaffClaimApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffClaimForApprovalCode,Database::"FIN-Staff Claims Header",OnCancelStaffClaimApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffAdvanceForApprovalCode,Database::"FIN-Staff Advance Header",OnSendStaffAdvanceApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffAdvanceForApprovalCode,Database::"FIN-Staff Advance Header",OnCancelStaffAdvanceApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode,Database::"FIN-Staff Advance Surr. Header",OnSendStaffAdvanceSurrenderApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffAdvanceSurrenderForApprovalCode,Database::"FIN-Staff Advance Surr. Header",OnCancelStaffAdvanceSurrenderApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendImprestForApprovalCode,Database::"FIN-Imprest Header",OnSendImprestApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelImprestForApprovalCode,Database::"FIN-Imprest Header",OnCancelImprestApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendImprestSurrenderForApprovalCode,Database::"FIN-Imprest Surr. Header",OnSendImprestSurrenderApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelImprestSurrenderForApprovalCode,Database::"FIN-Imprest Surr. Header",OnCancelImprestSurrenderApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStoreRequisitionForApprovalCode,Database::"PROC-Store Requistion Header",OnSendStoreRequisitionApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStoreRequisitionForApprovalCode,Database::"PROC-Store Requistion Header",OnCancelStoreRequisitionApprovalRequestTxt,0,false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendBudgetForApprovalCode,Database::"G/L Budget Name",OnSendBudgetApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelBudgetForApprovalCode,Database::"G/L Budget Name",OnCancelBudgetApprovalRequestTxt,0,false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrLeaveForApprovalCode,Database::"HRM-Leave Requisition",OnSendHrLeaveApprovalRequestTxt,0,false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrLeaveForApprovalCode,Database::"HRM-Leave Requisition",OnCancelHrLeaveApprovalRequestTxt,0,false);
    end;

    local procedure RunWorkflowOnSendApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApprovalRequest'));
    end;

    [EventSubscriber(Objecttype::Codeunit, 39005494, 'OnSendDocForApproval', '', false, false)]

    procedure RunWorkflowOnSendApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
          Database::"FIN-Payments Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendPaymentForApprovalCode,Variant);
          Database::"FIN-InterBank Transfers":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendInterbankForApprovalCode,Variant);
          Database::"FIN-Staff Claims Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffClaimForApprovalCode,Variant);
          Database::"FIN-Staff Advance Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffAdvanceForApprovalCode,Variant);
          Database::"FIN-Staff Advance Surr. Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode,Variant);
          Database::"FIN-Imprest Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendImprestForApprovalCode,Variant);
          Database::"FIN-Imprest Surr. Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendImprestSurrenderForApprovalCode,Variant);
          Database::"PROC-Store Requistion Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendStoreRequisitionForApprovalCode,Variant);

          Database::"G/L Budget Name":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendBudgetForApprovalCode,Variant);



          Database::"HRM-Leave Requisition":
          WorkflowManagement.HandleEvent(RunWorkflowOnSendHrLeaveForApprovalCode,Variant);


          else
            Error(UnsupportedRecordTypeErr,RecRef.Caption);
        end;
    end;

    [EventSubscriber(Objecttype::Codeunit, 39005494, 'OnCancelDocApprovalRequest', '', false, false)]

    procedure RunWorkflowOnCancelApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
          Database::"FIN-Payments Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelPaymentForApprovalCode,Variant);
          Database::"FIN-InterBank Transfers":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelInterbankForApprovalCode,Variant);
          Database::"FIN-Staff Claims Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffClaimForApprovalCode,Variant);
          Database::"FIN-Staff Advance Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffAdvanceForApprovalCode,Variant);
          Database::"FIN-Staff Advance Surr. Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffAdvanceSurrenderForApprovalCode,Variant);
          Database::"FIN-Imprest Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelImprestForApprovalCode,Variant);
          Database::"FIN-Imprest Surr. Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelImprestSurrenderForApprovalCode,Variant);
          Database::"PROC-Store Requistion Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelStoreRequisitionForApprovalCode,Variant);

          Database::"G/L Budget Name":
            WorkflowManagement.HandleEvent(RunWorkflowOnCancelBudgetForApprovalCode,Variant);

          Database::"HRM-Leave Requisition":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrLeaveForApprovalCode,Variant);

          else
            Error(UnsupportedRecordTypeErr,RecRef.Caption);
        end;
    end;


    procedure ReOpen(var Variant: Variant)
    var
        RecRef: RecordRef;
        PaymentsHeader: Record UnknownRecord61688;
        StaffClaimsHeader: Record UnknownRecord61602;
        StaffAdvanceHeader: Record UnknownRecord61197;
        StaffAdvanceSurrenderHeader: Record UnknownRecord61199;
        ImprestHeader: Record UnknownRecord61704;
        ImprestSurrenderHeader: Record UnknownRecord61504;
        StoreRequistionHeader: Record UnknownRecord61399;
        InterBankTransfers: Record UnknownRecord61500;
        Budget: Record "G/L Budget Name";
        Hrleave: Record UnknownRecord61125;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
          Database::"FIN-Payments Header":
            begin
             RecRef.SetTable(PaymentsHeader);
             PaymentsHeader.Validate(Status,PaymentsHeader.Status::Pending);
             PaymentsHeader.Modify;
             Variant := PaymentsHeader;
            end;
          Database::"FIN-Staff Claims Header":
            begin
             RecRef.SetTable(StaffClaimsHeader);
             StaffClaimsHeader.Validate(Status,StaffClaimsHeader.Status::Pending);
             StaffClaimsHeader.Modify;
             Variant := StaffClaimsHeader;
            end;
          Database::"FIN-Staff Advance Header":
            begin
             RecRef.SetTable(StaffAdvanceHeader);
             StaffAdvanceHeader.Validate(Status,StaffAdvanceHeader.Status::Pending);
             StaffAdvanceHeader.Modify;
             Variant := StaffAdvanceHeader;
            end;
          Database::"FIN-Staff Advance Surr. Header":
            begin
             RecRef.SetTable(StaffAdvanceSurrenderHeader);
             StaffAdvanceSurrenderHeader.Validate(Status,StaffAdvanceSurrenderHeader.Status::Pending);
             StaffAdvanceSurrenderHeader.Modify;
             Variant := StaffAdvanceSurrenderHeader;
            end;
          Database::"FIN-Imprest Header":
            begin
             RecRef.SetTable(ImprestHeader);
             ImprestHeader.Validate(Status,ImprestHeader.Status::Pending);
             ImprestHeader.Modify;
             Variant := ImprestHeader;
            end;
          Database::"FIN-Imprest Surr. Header":
            begin
             RecRef.SetTable(ImprestSurrenderHeader);
             ImprestSurrenderHeader.Validate(Status,ImprestSurrenderHeader.Status::Pending);
             ImprestSurrenderHeader.Modify;
             Variant := ImprestSurrenderHeader;
            end;
          Database::"PROC-Store Requistion Header":
            begin
             RecRef.SetTable(StoreRequistionHeader);
             StoreRequistionHeader.Validate(Status,StoreRequistionHeader.Status::Open);
             StoreRequistionHeader.Modify;
             Variant := StoreRequistionHeader;
            end;
               Database::"FIN-InterBank Transfers":
            begin
             RecRef.SetTable(InterBankTransfers);
             InterBankTransfers.Validate(Status,InterBankTransfers.Status::Pending);
             InterBankTransfers.Modify;
             Variant := InterBankTransfers;
            end;


        Database::"HRM-Leave Requisition":
            begin
             RecRef.SetTable(Hrleave);
             Hrleave.Validate(Status,Hrleave.Status::Open);
             Hrleave.Modify;
             Variant := Hrleave;
            end;


          else
            Error(UnsupportedRecordTypeErr,RecRef.Caption);
        end
    end;


    procedure Release(var Variant: Variant)
    var
        RecRef: RecordRef;
        PaymentsHeader: Record UnknownRecord61688;
        StaffClaimsHeader: Record UnknownRecord61602;
        StaffAdvanceHeader: Record UnknownRecord61197;
        StaffAdvanceSurrenderHeader: Record UnknownRecord61199;
        ImprestHeader: Record UnknownRecord61704;
        ImprestSurrenderHeader: Record UnknownRecord61504;
        StoreRequistionHeader: Record UnknownRecord61399;
        InterBankTransfers: Record UnknownRecord61500;
        Budget: Record "G/L Budget Name";
        Hrleave: Record UnknownRecord61125;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
          Database::"FIN-Payments Header":
            begin
             RecRef.SetTable(PaymentsHeader);
             PaymentsHeader.Validate(Status,PaymentsHeader.Status::Approved);
             PaymentsHeader.Modify;
             Variant := PaymentsHeader;
            end;
          Database::"FIN-Staff Claims Header":
            begin
             RecRef.SetTable(StaffClaimsHeader);
             StaffClaimsHeader.Validate(Status,StaffClaimsHeader.Status::Approved);
             StaffClaimsHeader.Modify;
             Variant := StaffClaimsHeader;
            end;
          Database::"FIN-Staff Advance Header":
            begin
             RecRef.SetTable(StaffAdvanceHeader);
             StaffAdvanceHeader.Validate(Status,StaffAdvanceHeader.Status::Approved);
             StaffAdvanceHeader.Modify;
             Variant := StaffAdvanceHeader;
            end;
          Database::"FIN-Staff Advance Surr. Header":
            begin
             RecRef.SetTable(StaffAdvanceSurrenderHeader);
             StaffAdvanceSurrenderHeader.Validate(Status,StaffAdvanceSurrenderHeader.Status::Approved);
             StaffAdvanceSurrenderHeader.Modify;
             Variant := StaffAdvanceSurrenderHeader;
            end;
          Database::"FIN-Imprest Header":
            begin
             RecRef.SetTable(ImprestHeader);
             ImprestHeader.Validate(Status,ImprestHeader.Status::Approved);
             ImprestHeader.Modify;
             Variant := ImprestHeader;
            end;
          Database::"FIN-Imprest Surr. Header":
            begin
             RecRef.SetTable(ImprestSurrenderHeader);
             ImprestSurrenderHeader.Validate(Status,ImprestSurrenderHeader.Status::Approved);
             ImprestSurrenderHeader.Modify;
             Variant := ImprestSurrenderHeader;
            end;
          Database::"PROC-Store Requistion Header":
            begin
             RecRef.SetTable(StoreRequistionHeader);
             StoreRequistionHeader.Validate(Status,StoreRequistionHeader.Status::Released);
             StoreRequistionHeader.Modify;
             Variant := StoreRequistionHeader;
            end;
          Database::"FIN-InterBank Transfers":
            begin
             RecRef.SetTable(InterBankTransfers);
             InterBankTransfers.Validate(Status,InterBankTransfers.Status::Approved);
             InterBankTransfers.Modify;
             Variant := InterBankTransfers;
            end;

         Database::"HRM-Leave Requisition":
            begin
             RecRef.SetTable(Hrleave);
             Hrleave.Validate(Status,Hrleave.Status::"Pending Approval");
             Hrleave.Modify;
             //Hrleave.CreateLeaveLedgerEntries;
             Variant := Hrleave;
            end;

            //ERROR(UnsupportedRecordTypeErr,RecRef.CAPTION);
        end;
    end;


    procedure SetStatusToPending(var Variant: Variant)
    var
        RecRef: RecordRef;
        PaymentsHeader: Record UnknownRecord61688;
        StaffClaimsHeader: Record UnknownRecord61602;
        StaffAdvanceHeader: Record UnknownRecord61197;
        StaffAdvanceSurrenderHeader: Record UnknownRecord61199;
        ImprestHeader: Record UnknownRecord61704;
        ImprestSurrenderHeader: Record UnknownRecord61504;
        StoreRequistionHeader: Record UnknownRecord61399;
        InterBankTransfers: Record UnknownRecord61500;
        Budget: Record "G/L Budget Name";
        Hrleave: Record UnknownRecord61125;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
          Database::"FIN-Payments Header":
            begin
             RecRef.SetTable(PaymentsHeader);
             PaymentsHeader.Validate(Status,PaymentsHeader.Status::"Pending Approval");
             PaymentsHeader.Modify;
             Variant := PaymentsHeader;
            end;
          Database::"FIN-Staff Claims Header":
            begin
             RecRef.SetTable(StaffClaimsHeader);
             StaffClaimsHeader.Validate(Status,StaffClaimsHeader.Status::"Pending Approval");
             StaffClaimsHeader.Modify;
             Variant := StaffClaimsHeader;
            end;
          Database::"FIN-Staff Advance Header":
            begin
             RecRef.SetTable(StaffAdvanceHeader);
             StaffAdvanceHeader.Validate(Status,StaffAdvanceHeader.Status::"Pending Approval");
             StaffAdvanceHeader.Modify;
             Variant := StaffAdvanceHeader;
            end;
          Database::"FIN-Staff Advance Surr. Header":
            begin
             RecRef.SetTable(StaffAdvanceSurrenderHeader);
             StaffAdvanceSurrenderHeader.Validate(Status,StaffAdvanceSurrenderHeader.Status::"Pending Approval");
             StaffAdvanceSurrenderHeader.Modify;
             Variant := StaffAdvanceSurrenderHeader;
            end;
          Database::"FIN-Imprest Header":
            begin
             RecRef.SetTable(ImprestHeader);
             ImprestHeader.Validate(Status,ImprestHeader.Status::"Pending Approval");
             ImprestHeader.Modify;
             Variant := ImprestHeader;
            end;
          Database::"FIN-Imprest Surr. Header":
            begin
             RecRef.SetTable(ImprestSurrenderHeader);
             ImprestSurrenderHeader.Validate(Status,ImprestSurrenderHeader.Status::"Pending Approval");
             ImprestSurrenderHeader.Modify;
             Variant := ImprestSurrenderHeader;
            end;
          Database::"PROC-Store Requistion Header":
            begin
             RecRef.SetTable(StoreRequistionHeader);
             StoreRequistionHeader.Validate(Status,StoreRequistionHeader.Status::"Pending Approval");
             StoreRequistionHeader.Modify;
             Variant := StoreRequistionHeader;
            end;
            Database::"FIN-InterBank Transfers":
            begin
             RecRef.SetTable(InterBankTransfers);
             InterBankTransfers.Validate(Status,InterBankTransfers.Status::"Pending Approval");
             InterBankTransfers.Modify;
             Variant := InterBankTransfers;
            end;


        Database::"HRM-Leave Requisition":
            begin
             RecRef.SetTable(Hrleave);
             Hrleave.Validate(Status,Hrleave.Status::Released);
             Hrleave.Modify;
             Variant := Hrleave;
            end;


           else
            Error(UnsupportedRecordTypeErr,RecRef.Caption);
        end
    end;
}

