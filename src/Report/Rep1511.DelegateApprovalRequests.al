#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1511 "Delegate Approval Requests"
{
    Caption = 'Delegate Approval Requests';
    ProcessingOnly = true;
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
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        ApprovalEntry.SetRange(Status,ApprovalEntry.Status::Open);
        if ApprovalEntry.FindSet(true) then
          repeat
            //IF NOT (FORMAT(ApprovalEntry."Delegation Date Formula") = '') THEN
            //  IF CALCDATE(ApprovalEntry."Delegation Date Formula",DT2DATE(ApprovalEntry."Date-Time Sent for Approval")) <= TODAY THEN
                ApprovalsMgmt.DelegateSelectedApprovalRequest(ApprovalEntry,false);
          until ApprovalEntry.Next = 0;
    end;
}

