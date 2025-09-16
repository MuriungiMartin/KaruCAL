#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1509 "Send Overdue Appr. Notif."
{
    Caption = 'Send Overdue Approval Notifications';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    UseRequestPage = false;

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if not ApprovalsMgmt.IsOverdueNotificationsWorkflowEnabled then
          Error(NoWorkflowEnabledErr);

        OnSendOverdueNotifications;
    end;

    var
        NoWorkflowEnabledErr: label 'There is no workflow enabled for sending overdue approval notifications.';

    [IntegrationEvent(false, false)]
    local procedure OnSendOverdueNotifications()
    begin
    end;
}

