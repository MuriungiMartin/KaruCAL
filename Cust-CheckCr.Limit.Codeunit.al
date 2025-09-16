#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 312 "Cust-Check Cr. Limit"
{
    Permissions = TableData "My Notifications"=rimd;

    trigger OnRun()
    begin
    end;

    var
        InstructionMgt: Codeunit "Instruction Mgt.";
        CustCheckCreditLimit: Page "Check Credit Limit";
        InstructionTypeTxt: label 'Check Cr. Limit';
        GetDetailsTxt: label 'Details...';
        ShowNotificationDetailsTxt: label 'ShowNotificationDetails', Locked=true;
        CreditLimitNotificationTxt: label 'Customer exceeds credit limit.';
        CreditLimitNotificationDescriptionTxt: label 'Show warning when a sales document will exceed the customer''s credit limit.';
        OverdueBalanceNotificationTxt: label 'Customer has overdue balance.';
        OverdueBalanceNotificationDescriptionTxt: label 'Show warning when a sales document is for a customer with an overdue balance.';


    procedure GenJnlLineCheck(GenJnlLine: Record "Gen. Journal Line")
    begin
        if not GuiAllowed then
          exit;

        if CustCheckCreditLimit.GenJnlLineShowWarning(GenJnlLine) then
          CreateAndSendNotification;
    end;


    procedure SalesHeaderCheck(SalesHeader: Record "Sales Header") CreditLimitExceeded: Boolean
    begin
        if not GuiAllowed then
          exit;

        if not CustCheckCreditLimit.SalesHeaderShowWarning(SalesHeader) then
          SalesHeader.OnCustomerCreditLimitNotExceeded
        else
          if InstructionMgt.IsEnabled(GetInstructionType(Format(SalesHeader."Document Type"),SalesHeader."No.")) then begin
            CreditLimitExceeded := true;
            CreateAndSendNotification;
            SalesHeader.OnCustomerCreditLimitExceeded;
          end;
    end;


    procedure SalesLineCheck(SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if not GuiAllowed then
          exit;

        SalesHeader.Get(SalesLine."Document Type",SalesLine."Document No.");

        if not CustCheckCreditLimit.SalesLineShowWarning(SalesLine) then
          SalesHeader.OnCustomerCreditLimitNotExceeded
        else
          if InstructionMgt.IsEnabled(GetInstructionType(Format(SalesLine."Document Type"),SalesLine."Document No.")) then begin
            CreateAndSendNotification;
            SalesHeader.OnCustomerCreditLimitExceeded;
          end;
    end;


    procedure ServiceHeaderCheck(ServiceHeader: Record "Service Header")
    begin
        if not GuiAllowed then
          exit;

        if CustCheckCreditLimit.ServiceHeaderShowWarning(ServiceHeader) then
          CreateAndSendNotification;
    end;


    procedure ServiceLineCheck(ServiceLine: Record "Service Line")
    begin
        if not GuiAllowed then
          exit;

        if CustCheckCreditLimit.ServiceLineShowWarning(ServiceLine) then
          CreateAndSendNotification;
    end;


    procedure ServiceContractHeaderCheck(ServiceContractHeader: Record "Service Contract Header")
    begin
        if not GuiAllowed then
          exit;

        if CustCheckCreditLimit.ServiceContractHeaderShowWarning(ServiceContractHeader) then
          CreateAndSendNotification;
    end;


    procedure GetInstructionType(DocumentType: Code[30];DocumentNumber: Code[20]): Code[50]
    begin
        exit(CopyStr(StrSubstNo('%1 %2 %3',DocumentType,DocumentNumber,InstructionTypeTxt),1,50));
    end;


    procedure BlanketSalesOrderToOrderCheck(SalesOrderHeader: Record "Sales Header")
    begin
        if not GuiAllowed then
          exit;

        if CustCheckCreditLimit.SalesHeaderShowWarning(SalesOrderHeader) then
          CreateAndSendNotification;
    end;


    procedure ShowNotificationDetails(CreditLimitNotification: Notification)
    var
        CreditLimitNotificationPage: Page "Credit Limit Notification";
    begin
        CreditLimitNotificationPage.SetHeading(CreditLimitNotification.Message);
        CreditLimitNotificationPage.InitializeFromNotificationVar(CreditLimitNotification);
        CreditLimitNotificationPage.RunModal;
    end;

    local procedure CreateAndSendNotification()
    var
        CreditLimitNotification: Notification;
    begin
        CreditLimitNotification.ID(CustCheckCreditLimit.GetNotificationId);
        CreditLimitNotification.Message(CustCheckCreditLimit.GetHeading);
        CreditLimitNotification.Scope(Notificationscope::LocalScope);
        CreditLimitNotification.AddAction(GetDetailsTxt,Codeunit::"Cust-Check Cr. Limit",ShowNotificationDetailsTxt);
        CustCheckCreditLimit.PopulateDataOnNotification(CreditLimitNotification);
        CreditLimitNotification.Send;
    end;


    procedure GetCreditLimitNotificationId(): Guid
    begin
        exit('C80FEEDA-802C-4879-B826-34A10FB77087');
    end;


    procedure GetOverdueBalanceNotificationId(): Guid
    begin
        exit('EC8348CB-07C1-499A-9B70-B3B081A33C99');
    end;


    procedure IsCreditLimitNotificationEnabled(Customer: Record Customer): Boolean
    var
        MyNotifications: Record "My Notifications";
    begin
        exit(MyNotifications.IsEnabledForRecord(GetCreditLimitNotificationId,Customer));
    end;


    procedure IsOverdueBalanceNotificationEnabled(Customer: Record Customer): Boolean
    var
        MyNotifications: Record "My Notifications";
    begin
        exit(MyNotifications.IsEnabledForRecord(GetOverdueBalanceNotificationId,Customer));
    end;

    [EventSubscriber(Objecttype::Page, 1518, 'OnInitializingNotificationWithDefaultState', '', false, false)]
    local procedure OnInitializingNotificationWithDefaultState()
    var
        MyNotifications: Record "My Notifications";
    begin
        MyNotifications.InsertDefaultWithTableNum(GetCreditLimitNotificationId,
          CreditLimitNotificationTxt,
          CreditLimitNotificationDescriptionTxt,
          Database::Customer);
        MyNotifications.InsertDefaultWithTableNum(GetOverdueBalanceNotificationId,
          OverdueBalanceNotificationTxt,
          OverdueBalanceNotificationDescriptionTxt,
          Database::Customer);
    end;
}

