#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1510 "Notification Management"
{
    Permissions = TableData "Overdue Approval Entry"=i,
                  TableData UnknownTableData1510=r,
                  TableData "Notification Entry"=rimd;

    trigger OnRun()
    begin
    end;

    var
        OverdueEntriesMsg: label 'Overdue approval entries have been created.';
        SalesTxt: label 'Sales';
        PurchaseTxt: label 'Purchase';
        ServiceTxt: label 'Service';
        SalesInvoiceTxt: label 'Sales Invoice';
        PurchaseInvoiceTxt: label 'Purchase Invoice';
        ServiceInvoiceTxt: label 'Service Invoice';
        SalesCreditMemoTxt: label 'Sales Credit Memo';
        PurchaseCreditMemoTxt: label 'Purchase Credit Memo';
        ServiceCreditMemoTxt: label 'Service Credit Memo';
        ActionNewRecordTxt: label 'has been created.', Comment='E.g. Sales Invoice 10000 has been created.';
        ActionApproveTxt: label 'requires your approval.', Comment='E.g. Sales Invoice 10000 requires your approval.';
        ActionApprovedTxt: label 'has been approved.', Comment='E.g. Sales Invoice 10000 has been approved.';
        ActionApprovalCreatedTxt: label 'approval request has been created.', Comment='E.g. Sales Invoice 10000 approval request has been created.';
        ActionApprovalCanceledTxt: label 'approval request has been canceled.', Comment='E.g. Sales Invoice 10000 approval request has been canceled.';
        ActionApprovalRejectedTxt: label 'approval has been rejected.', Comment='E.g. Sales Invoice 10000 approval request has been rejected.';
        ActionOverdueTxt: label 'has a pending approval.', Comment='E.g. Sales Invoice 10000 has a pending approval.';


    procedure CreateOverdueNotifications(WorkflowStepArgument: Record "Workflow Step Argument")
    var
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        OverdueApprovalEntry: Record "Overdue Approval Entry";
        NotificationEntry: Record "Notification Entry";
    begin
        if UserSetup.FindSet then
          repeat
            ApprovalEntry.Reset;
            ApprovalEntry.SetRange("Approver ID",UserSetup."User ID");
            ApprovalEntry.SetRange(Status,ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Due Date",'<=%1',Today);
            if ApprovalEntry.FindSet then
              repeat
                InsertOverdueEntry(ApprovalEntry,OverdueApprovalEntry);
                NotificationEntry.CreateNew(NotificationEntry.Type::Overdue,
                  UserSetup."User ID",OverdueApprovalEntry,WorkflowStepArgument."Link Target Page",
                  WorkflowStepArgument."Custom Link");
              until ApprovalEntry.Next = 0;
          until UserSetup.Next = 0;

        Message(OverdueEntriesMsg);
    end;

    local procedure InsertOverdueEntry(ApprovalEntry: Record "Approval Entry";var OverdueApprovalEntry: Record "Overdue Approval Entry")
    var
        User: Record User;
        UserSetup: Record "User Setup";
    begin
        with OverdueApprovalEntry do begin
          Init;
          "Approver ID" := ApprovalEntry."Approver ID";
          User.SetRange("User Name",ApprovalEntry."Approver ID");
          if User.FindFirst then begin
            "Sent to Name" := CopyStr(User."Full Name",1,MaxStrLen("Sent to Name"));
            UserSetup.Get(User."User Name");
          end;

          "Table ID" := ApprovalEntry."Table ID";
          "Document Type" := ApprovalEntry."Document Type";
          "Document No." := ApprovalEntry."Document No.";
          "Sent to ID" := ApprovalEntry."Approver ID";
          "Sent Date" := Today;
          "Sent Time" := Time;
          "E-Mail" := UserSetup."E-Mail";
          "Sequence No." := ApprovalEntry."Sequence No.";
          "Due Date" := ApprovalEntry."Due Date";
          "Approval Code" := ApprovalEntry."Approval Code";
          "Approval Type" := ApprovalEntry."Approval Type";
          "Limit Type" := ApprovalEntry."Limit Type";
         // "Record ID to Approve" := ApprovalEntry.CanCurrentUserEdit;
          Insert;
        end;
    end;


    procedure CreateDefaultNotificationSetup(NotificationType: Option)
    var
        NotificationSetup: Record "Notification Setup";
    begin
        if DefaultNotificationEntryExists(NotificationType) then
          exit;

        NotificationSetup.Init;
        NotificationSetup.Validate("Notification Type",NotificationType);
        NotificationSetup.Validate("Notification Method",NotificationSetup."notification method"::Email);
        NotificationSetup.Insert(true);
    end;

    local procedure DefaultNotificationEntryExists(NotificationType: Option): Boolean
    var
        NotificationSetup: Record "Notification Setup";
    begin
        NotificationSetup.SetRange("User ID",'');
        NotificationSetup.SetRange("Notification Type",NotificationType);
        exit(not NotificationSetup.IsEmpty)
    end;


    procedure MoveNotificationEntryToSentNotificationEntries(var NotificationEntry: Record "Notification Entry";NotificationBody: Text;AggregatedNotifications: Boolean;NotificationMethod: Option)
    var
        SentNotificationEntry: Record "Sent Notification Entry";
        InitialSentNotificationEntry: Record "Sent Notification Entry";
    begin
        if AggregatedNotifications then begin
          if NotificationEntry.FindSet then begin
            InitialSentNotificationEntry.NewRecord(NotificationEntry,NotificationBody,NotificationMethod);
            while NotificationEntry.Next <> 0 do begin
              SentNotificationEntry.NewRecord(NotificationEntry,NotificationBody,NotificationMethod);
              SentNotificationEntry.Validate("Aggregated with Entry",InitialSentNotificationEntry.ID);
              SentNotificationEntry.Modify(true);
            end;
          end;
          NotificationEntry.DeleteAll(true);
        end else begin
          SentNotificationEntry.NewRecord(NotificationEntry,NotificationBody,NotificationMethod);
          NotificationEntry.Delete(true);
        end;
    end;


    procedure GetDocumentTypeAndNumber(var RecRef: RecordRef;var DocumentType: Text;var DocumentNo: Text)
    var
        FieldRef: FieldRef;
    begin
        case RecRef.Number of
          Database::"Incoming Document":
            begin
              DocumentType := RecRef.Caption;
              FieldRef := RecRef.Field(2);
              DocumentNo := Format(FieldRef.Value);
            end;
          Database::"Sales Header":
            begin
              FieldRef := RecRef.Field(1);
              DocumentType := SalesTxt + ' ' + Format(FieldRef.Value);
              FieldRef := RecRef.Field(3);
              DocumentNo := Format(FieldRef.Value);
            end;
          Database::"Purchase Header":
            begin
              FieldRef := RecRef.Field(1);
              DocumentType := PurchaseTxt + ' ' + Format(FieldRef.Value);
              FieldRef := RecRef.Field(3);
              DocumentNo := Format(FieldRef.Value);
            end;
          Database::"Service Header":
            begin
              FieldRef := RecRef.Field(1);
              DocumentType := ServiceTxt + ' ' + Format(FieldRef.Value);
              FieldRef := RecRef.Field(3);
              DocumentNo := Format(FieldRef.Value);
            end;
          Database::"Sales Invoice Header":
            begin
              DocumentType := SalesInvoiceTxt;
              FieldRef := RecRef.Field(3);
              DocumentNo := Format(FieldRef.Value);
            end;
          Database::"Purch. Inv. Header":
            begin
              DocumentType := PurchaseInvoiceTxt;
              FieldRef := RecRef.Field(3);
              DocumentNo := Format(FieldRef.Value);
            end;
          Database::"Service Invoice Header":
            begin
              DocumentType := ServiceInvoiceTxt;
              FieldRef := RecRef.Field(3);
              DocumentNo := Format(FieldRef.Value);
            end;
          Database::"Sales Cr.Memo Header":
            begin
              DocumentType := SalesCreditMemoTxt;
              FieldRef := RecRef.Field(3);
              DocumentNo := Format(FieldRef.Value);
            end;
          Database::"Purch. Cr. Memo Hdr.":
            begin
              DocumentType := PurchaseCreditMemoTxt;
              FieldRef := RecRef.Field(3);
              DocumentNo := Format(FieldRef.Value);
            end;
          Database::"Service Cr.Memo Header":
            begin
              DocumentType := ServiceCreditMemoTxt;
              FieldRef := RecRef.Field(3);
              DocumentNo := Format(FieldRef.Value);
            end;
          Database::"Gen. Journal Line":
            begin
              DocumentType := RecRef.Caption;
              FieldRef := RecRef.Field(1);
              DocumentNo := Format(FieldRef.Value);
              FieldRef := RecRef.Field(51);
              DocumentNo += ',' + Format(FieldRef.Value);
              FieldRef := RecRef.Field(2);
              DocumentNo += ',' + Format(FieldRef.Value);
            end;
          Database::"Gen. Journal Batch":
            begin
              DocumentType := RecRef.Caption;
              FieldRef := RecRef.Field(1);
              DocumentNo := Format(FieldRef.Value);
              FieldRef := RecRef.Field(2);
              DocumentNo += ',' + Format(FieldRef.Value);
            end;
          Database::Customer,
          Database::Vendor,
          Database::Item:
            begin
              DocumentType := RecRef.Caption;
              FieldRef := RecRef.Field(1);
              DocumentNo := Format(FieldRef.Value);
            end;
          Database::"Aca-Special Exams Details":
            begin
            FieldRef:=RecRef.Field(4);
          DocumentNo:=Format(FieldRef.Value);
        end;
          else begin
            DocumentType := RecRef.Caption;
            FieldRef := RecRef.Field(3);
            DocumentNo := Format(FieldRef.Value);
          end;
        end;
    end;


    procedure GetActionTextFor(var NotificationEntry: Record "Notification Entry"): Text
    var
        ApprovalEntry: Record "Approval Entry";
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
    begin
        case NotificationEntry.Type of
          NotificationEntry.Type::"New Record":
            exit(ActionNewRecordTxt);
          NotificationEntry.Type::Approval:
            begin
              DataTypeManagement.GetRecordRef(NotificationEntry."Triggered By Record",RecRef);
              RecRef.SetTable(ApprovalEntry);
              case ApprovalEntry.Status of
                ApprovalEntry.Status::Open:
                  exit(ActionApproveTxt);
                ApprovalEntry.Status::Canceled:
                  exit(ActionApprovalCanceledTxt);
                ApprovalEntry.Status::Rejected:
                  exit(ActionApprovalRejectedTxt);
                ApprovalEntry.Status::Created:
                  exit(ActionApprovalCreatedTxt);
                ApprovalEntry.Status::Approved:
                  exit(ActionApprovedTxt);
              end;
            end;
          NotificationEntry.Type::Overdue:
            exit(ActionOverdueTxt);
        end;
    end;
}

