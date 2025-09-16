#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1430 "Role Center Notification Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        EvaluationNotificationIdTxt: label 'cb28c63d-4daf-453a-b41b-a8de9963d563', Locked=true;
        TrialNotificationIdTxt: label '2751b488-ca52-42ef-b6d7-d7b4ba841e80', Locked=true;
        TrialSuspendedNotificationIdTxt: label '2751b488-ca52-42ef-b6d7-d7b4ba841e80', Locked=true;
        PaidWarningNotificationIdTxt: label '2751b488-ca52-42ef-b6d7-d7b4ba841e80', Locked=true;
        PaidSuspendedNotificationIdTxt: label '2751b488-ca52-42ef-b6d7-d7b4ba841e80', Locked=true;
        TrialNotificationDaysSinceStartTxt: label '1', Locked=true;
        EvaluationNotificationLinkTxt: label 'Start trial...';
        TrialNotificationLinkTxt: label 'Buy subscription...';
        TrialSuspendedNotificationLinkTxt: label 'Renew subscription...';
        PaidWarningNotificationLinkTxt: label 'Renew subscription...';
        PaidSuspendedNotificationLinkTxt: label 'Renew subscription...';
        EvaluationNotificationMsg: label 'Want to try with your own company data for a free %1-day trial?', Comment='%1=Trial duration in days';
        TrialNotificationMsg: label 'Your trial period expires in %1 days. Do you want to get a subscription?', Comment='%1=Count of days until trial expires';
        TrialSuspendedNotificationMsg: label 'Your trial period has expired. Unless you renew, we will delete your data in %1 days.', Comment='%1=Count of days until block of access';
        PaidWarningNotificationMsg: label 'Your subscription expires in %1 days. Renew soon to keep your work.', Comment='%1=Count of days until block of access';
        PaidSuspendedNotificationMsg: label 'Your subscription has expired. Unless you renew, we will delete your data in %1 days.', Comment='%1=Count of days until data deletion';
        ChooseCompanyMsg: label 'Choose a non-evaluation company to start your trial.';
        SignOutToStartTrialMsg: label 'We''re glad you''ve chosen to explore Dynamics 365 for Financials!\\To get going, sign in again.';

    local procedure CreateAndSendEvaluationNotification()
    var
        EvaluationNotification: Notification;
        TrialTotalDays: Integer;
    begin
        TrialTotalDays := GetTrialTotalDays;
        EvaluationNotification.ID := GetEvaluationNotificationId;
        EvaluationNotification.Message := StrSubstNo(EvaluationNotificationMsg,TrialTotalDays);
        EvaluationNotification.Scope := Notificationscope::LocalScope;
        EvaluationNotification.AddAction(
          EvaluationNotificationLinkTxt,Codeunit::"Role Center Notification Mgt.",'EvaluationNotificationAction');
        EvaluationNotification.Send;
    end;

    local procedure CreateAndSendTrialNotification()
    var
        TrialNotification: Notification;
        RemainingDays: Integer;
    begin
        RemainingDays := GetLicenseRemainingDays;
        TrialNotification.ID := GetTrialNotificationId;
        TrialNotification.Message := StrSubstNo(TrialNotificationMsg,RemainingDays);
        TrialNotification.Scope := Notificationscope::LocalScope;
        TrialNotification.AddAction(
          TrialNotificationLinkTxt,Codeunit::"Role Center Notification Mgt.",'TrialNotificationAction');
        TrialNotification.Send;
    end;

    local procedure CreateAndSendTrialSuspendedNotification()
    var
        TrialSuspendedNotification: Notification;
        RemainingDays: Integer;
    begin
        RemainingDays := GetLicenseRemainingDays;
        TrialSuspendedNotification.ID := GetTrialSuspendedNotificationId;
        TrialSuspendedNotification.Message := StrSubstNo(TrialSuspendedNotificationMsg,RemainingDays);
        TrialSuspendedNotification.Scope := Notificationscope::LocalScope;
        TrialSuspendedNotification.AddAction(
          TrialSuspendedNotificationLinkTxt,Codeunit::"Role Center Notification Mgt.",'TrialSuspendedNotificationAction');
        TrialSuspendedNotification.Send;
    end;

    local procedure CreateAndSendPaidWarningNotification()
    var
        PaidWarningNotification: Notification;
        RemainingDays: Integer;
    begin
        RemainingDays := GetLicenseRemainingDays;
        PaidWarningNotification.ID := GetPaidWarningNotificationId;
        PaidWarningNotification.Message := StrSubstNo(PaidWarningNotificationMsg,RemainingDays);
        PaidWarningNotification.Scope := Notificationscope::LocalScope;
        PaidWarningNotification.AddAction(
          PaidWarningNotificationLinkTxt,Codeunit::"Role Center Notification Mgt.",'PaidWarningNotificationAction');
        PaidWarningNotification.Send;
    end;

    local procedure CreateAndSendPaidSuspendedNotification()
    var
        PaidSuspendedNotification: Notification;
        RemainingDays: Integer;
    begin
        RemainingDays := GetLicenseRemainingDays;
        PaidSuspendedNotification.ID := GetPaidSuspendedNotificationId;
        PaidSuspendedNotification.Message := StrSubstNo(PaidSuspendedNotificationMsg,RemainingDays);
        PaidSuspendedNotification.Scope := Notificationscope::LocalScope;
        PaidSuspendedNotification.AddAction(
          PaidSuspendedNotificationLinkTxt,Codeunit::"Role Center Notification Mgt.",'PaidSuspendedNotificationAction');
        PaidSuspendedNotification.Send;
    end;


    procedure GetEvaluationNotificationId(): Guid
    var
        EvaluationNotificationId: Guid;
    begin
        Evaluate(EvaluationNotificationId,EvaluationNotificationIdTxt);
        exit(EvaluationNotificationId);
    end;


    procedure GetTrialNotificationId(): Guid
    var
        TrialNotificationId: Guid;
    begin
        Evaluate(TrialNotificationId,TrialNotificationIdTxt);
        exit(TrialNotificationId);
    end;


    procedure GetTrialSuspendedNotificationId(): Guid
    var
        TrialSuspendedNotificationId: Guid;
    begin
        Evaluate(TrialSuspendedNotificationId,TrialSuspendedNotificationIdTxt);
        exit(TrialSuspendedNotificationId);
    end;


    procedure GetPaidWarningNotificationId(): Guid
    var
        PaidWarningNotificationId: Guid;
    begin
        Evaluate(PaidWarningNotificationId,PaidWarningNotificationIdTxt);
        exit(PaidWarningNotificationId);
    end;


    procedure GetPaidSuspendedNotificationId(): Guid
    var
        PaidSuspendedNotificationId: Guid;
    begin
        Evaluate(PaidSuspendedNotificationId,PaidSuspendedNotificationIdTxt);
        exit(PaidSuspendedNotificationId);
    end;

    local procedure AreNotificationsSupported(): Boolean
    var
        PermissionManager: Codeunit "Permission Manager";
    begin
        if not GuiAllowed then
          exit(false);

        exit(PermissionManager.SoftwareAsAService);
    end;

    local procedure IsEvaluationNotificationEnabled(): Boolean
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        if not IsEvaluationMode then
          exit(false);

        if RoleCenterNotifications.IsFirstLogon then
          exit(false);

        if RoleCenterNotifications.GetEvaluationNotificationState =
           RoleCenterNotifications."evaluation notification state"::Disabled
        then
          exit(false);

        exit(true);
    end;

    local procedure IsTrialNotificationEnabled(): Boolean
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        if not IsTrialMode then
          exit(false);

        if RoleCenterNotifications.IsFirstLogon then
          exit(false);

        if GetLicenseFullyUsedDays < GetTrialNotificationDaysSinceStart then
          exit(false);

        exit(IsBuyNotificationEnabled);
    end;

    local procedure IsTrialSuspendedNotificationEnabled(): Boolean
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        if not IsTrialSuspendedMode then
          exit(false);

        if RoleCenterNotifications.IsFirstLogon then
          exit(false);

        exit(IsBuyNotificationEnabled);
    end;

    local procedure IsPaidWarningNotificationEnabled(): Boolean
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        if not IsPaidWarningMode then
          exit(false);

        if RoleCenterNotifications.IsFirstLogon then
          exit(false);

        exit(IsBuyNotificationEnabled);
    end;

    local procedure IsPaidSuspendedNotificationEnabled(): Boolean
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        if not IsPaidSuspendedMode then
          exit(false);

        if RoleCenterNotifications.IsFirstLogon then
          exit(false);

        exit(IsBuyNotificationEnabled);
    end;


    procedure ShowNotifications(): Boolean
    var
        ResultEvaluation: Boolean;
        ResultTrial: Boolean;
        ResultTrialSuspended: Boolean;
        ResultPaidWarning: Boolean;
        ResultPaidSuspended: Boolean;
    begin
        if not AreNotificationsSupported then
          exit(false);

        if CurrentClientType = Clienttype::Web then
          ResultEvaluation := ShowEvaluationNotification;

        ResultTrial := ShowTrialNotification;
        ResultTrialSuspended := ShowTrialSuspendedNotification;
        ResultPaidWarning := ShowPaidWarningNotification;
        ResultPaidSuspended := ShowPaidSuspendedNotification;

        exit(
          ResultEvaluation or
          ResultTrial or ResultTrialSuspended or
          ResultPaidWarning or ResultPaidSuspended);
    end;


    procedure ShowEvaluationNotification(): Boolean
    var
        Company: Record Company;
    begin
        if not IsEvaluationNotificationEnabled then
          exit(false);

        // Verify, that the user has company setup rights
        if not Company.WritePermission then
          exit(false);

        CreateAndSendEvaluationNotification;
        exit(true);
    end;


    procedure ShowTrialNotification(): Boolean
    begin
        if not IsTrialNotificationEnabled then
          exit(false);

        CreateAndSendTrialNotification;
        exit(true);
    end;


    procedure ShowTrialSuspendedNotification(): Boolean
    begin
        if not IsTrialSuspendedNotificationEnabled then
          exit(false);

        CreateAndSendTrialSuspendedNotification;
        exit(true);
    end;


    procedure ShowPaidWarningNotification(): Boolean
    begin
        if not IsPaidWarningNotificationEnabled then
          exit(false);

        CreateAndSendPaidWarningNotification;
        exit(true);
    end;


    procedure ShowPaidSuspendedNotification(): Boolean
    begin
        if not IsPaidSuspendedNotificationEnabled then
          exit(false);

        CreateAndSendPaidSuspendedNotification;
        exit(true);
    end;


    procedure EvaluationNotificationAction(EvaluationNotification: Notification)
    begin
        StartTrial;
    end;


    procedure TrialNotificationAction(TrialNotification: Notification)
    begin
        BuySubscription;
    end;


    procedure TrialSuspendedNotificationAction(TrialSuspendedNotification: Notification)
    begin
        BuySubscription;
    end;


    procedure PaidWarningNotificationAction(PaidWarningNotification: Notification)
    begin
        BuySubscription;
    end;


    procedure PaidSuspendedNotificationAction(PaidSuspendedNotification: Notification)
    begin
        BuySubscription;
    end;

    local procedure IsEvaluationMode(): Boolean
    var
        TenantLicenseState: Record "Tenant License State";
        CurrentState: Option;
        PreviousState: Option;
    begin
        GetLicenseState(CurrentState,PreviousState);
        exit(CurrentState = TenantLicenseState.State::Evaluation);
    end;

    local procedure IsTrialMode(): Boolean
    var
        TenantLicenseState: Record "Tenant License State";
        CurrentState: Option;
        PreviousState: Option;
    begin
        GetLicenseState(CurrentState,PreviousState);
        exit(CurrentState = TenantLicenseState.State::Trial);
    end;

    local procedure IsTrialSuspendedMode(): Boolean
    var
        TenantLicenseState: Record "Tenant License State";
        CurrentState: Option;
        PreviousState: Option;
    begin
        GetLicenseState(CurrentState,PreviousState);
        exit((CurrentState = TenantLicenseState.State::Suspended) and (PreviousState = TenantLicenseState.State::Trial));
    end;

    local procedure IsPaidWarningMode(): Boolean
    var
        TenantLicenseState: Record "Tenant License State";
        CurrentState: Option;
        PreviousState: Option;
    begin
        GetLicenseState(CurrentState,PreviousState);
        exit((CurrentState = TenantLicenseState.State::Warning) and (PreviousState = TenantLicenseState.State::Paid));
    end;

    local procedure IsPaidSuspendedMode(): Boolean
    var
        TenantLicenseState: Record "Tenant License State";
        CurrentState: Option;
        PreviousState: Option;
    begin
        GetLicenseState(CurrentState,PreviousState);
        exit((CurrentState = TenantLicenseState.State::Suspended) and (PreviousState = TenantLicenseState.State::Paid));
    end;

    local procedure GetLicenseState(var CurrentState: Option;var PreviousState: Option)
    var
        TenantLicenseState: Record "Tenant License State";
    begin
        PreviousState := TenantLicenseState.State::Evaluation;
        if TenantLicenseState.Find('+') then begin
          CurrentState := TenantLicenseState.State;
          if (CurrentState = TenantLicenseState.State::Warning) or (CurrentState = TenantLicenseState.State::Suspended) then begin
            while TenantLicenseState.Next(-1) <> 0 do begin
              PreviousState := TenantLicenseState.State;
              if (PreviousState = TenantLicenseState.State::Trial) or (PreviousState = TenantLicenseState.State::Paid) then
                exit;
            end;
            PreviousState := TenantLicenseState.State::Paid;
          end;
        end else
          CurrentState := TenantLicenseState.State::Evaluation;
    end;


    procedure GetLicenseRemainingDays(): Integer
    var
        TenantLicenseState: Record "Tenant License State";
        DateFilterCalc: Codeunit "DateFilter-Calc";
        Now: DateTime;
        TimeDuration: Decimal;
        MillisecondsPerDay: BigInteger;
        RemainingDays: Integer;
    begin
        Now := DateFilterCalc.ConvertToUtcDateTime(CurrentDatetime);
        if TenantLicenseState.FindLast then
          if TenantLicenseState."End Date" > Now then begin
            TimeDuration := TenantLicenseState."End Date" - Now;
            MillisecondsPerDay := 86400000;
            RemainingDays := ROUND(TimeDuration / MillisecondsPerDay,1,'=');
            exit(RemainingDays);
          end;
        exit(0);
    end;

    local procedure GetLicenseFullyUsedDays(): Integer
    var
        TenantLicenseState: Record "Tenant License State";
        DateFilterCalc: Codeunit "DateFilter-Calc";
        Now: DateTime;
        TimeDuration: Decimal;
        MillisecondsPerDay: BigInteger;
        FullyUsedDays: Integer;
    begin
        Now := DateFilterCalc.ConvertToUtcDateTime(CurrentDatetime);
        if TenantLicenseState.FindLast then
          if Now > TenantLicenseState."Start Date" then begin
            TimeDuration := Now - TenantLicenseState."Start Date";
            MillisecondsPerDay := 86400000;
            FullyUsedDays := ROUND(TimeDuration / MillisecondsPerDay,1,'<');
            exit(FullyUsedDays);
          end;
        exit(0);
    end;


    procedure GetTrialTotalDays(): Integer
    var
        TenantLicenseState: Record "Tenant License State";
        TenantLicenseStateMgt: Codeunit "Tenant License State";
        TrialTotalDays: Integer;
    begin
        TrialTotalDays := TenantLicenseStateMgt.GetPeriod(TenantLicenseState.State::Trial);
        exit(TrialTotalDays);
    end;

    local procedure GetTrialNotificationDaysSinceStart(): Integer
    var
        DaysSinceStart: Integer;
    begin
        Evaluate(DaysSinceStart,TrialNotificationDaysSinceStartTxt);
        exit(DaysSinceStart);
    end;

    local procedure StartTrial()
    var
        UserPersonalization: Record "User Personalization";
        NewCompany: Text[30];
    begin
        if not GetMyCompany(NewCompany) then begin
          Message(ChooseCompanyMsg);
          CreateAndSendEvaluationNotification;
          exit;
        end;

        ClickEvaluationNotification;
        Commit;

        UserPersonalization.Get(UserSecurityId);
        // The wizard is started by OnBeforeValidate, it could raise an error if terms & conditions are not accepted
        UserPersonalization.Validate(Company,NewCompany);
        UserPersonalization.Modify(true);

        DisableEvaluationNotification;

        Message(SignOutToStartTrialMsg);
    end;

    local procedure BuySubscription()
    begin
        DisableBuyNotification;
        Page.Run(Page::"Buy Subscription");
    end;

    local procedure ClickEvaluationNotification()
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        RoleCenterNotifications.SetEvaluationNotificationState(RoleCenterNotifications."evaluation notification state"::Clicked);
    end;


    procedure DisableEvaluationNotification()
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        RoleCenterNotifications.SetEvaluationNotificationState(RoleCenterNotifications."evaluation notification state"::Disabled);
    end;


    procedure EnableEvaluationNotification()
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        RoleCenterNotifications.SetEvaluationNotificationState(RoleCenterNotifications."evaluation notification state"::Enabled);
    end;


    procedure IsEvaluationNotificationClicked(): Boolean
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        exit(RoleCenterNotifications.GetEvaluationNotificationState = RoleCenterNotifications."evaluation notification state"::Clicked);
    end;


    procedure DisableBuyNotification()
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        RoleCenterNotifications.SetBuyNotificationState(RoleCenterNotifications."buy notification state"::Disabled);
    end;


    procedure EnableBuyNotification()
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        RoleCenterNotifications.SetBuyNotificationState(RoleCenterNotifications."buy notification state"::Enabled);
    end;

    local procedure IsBuyNotificationEnabled(): Boolean
    var
        RoleCenterNotifications: Record "Role Center Notifications";
    begin
        exit(RoleCenterNotifications.GetBuyNotificationState <> RoleCenterNotifications."buy notification state"::Disabled);
    end;


    procedure CompanyNotSelectedMessage(): Text
    begin
        exit('');
    end;


    procedure EvaluationNotificationMessage(): Text
    begin
        exit(EvaluationNotificationMsg);
    end;


    procedure TrialNotificationMessage(): Text
    begin
        exit(TrialNotificationMsg);
    end;


    procedure TrialSuspendedNotificationMessage(): Text
    begin
        exit(TrialSuspendedNotificationMsg);
    end;


    procedure PaidWarningNotificationMessage(): Text
    begin
        exit(PaidWarningNotificationMsg);
    end;


    procedure PaidSuspendedNotificationMessage(): Text
    begin
        exit(PaidSuspendedNotificationMsg);
    end;

    local procedure GetMyCompany(var MyCompany: Text[30]): Boolean
    var
        SelectedCompany: Record Company;
        AllowedCompanies: Page "Allowed Companies";
    begin
        SelectedCompany.SetRange("Evaluation Company",false);
        SelectedCompany.FindFirst;
        if SelectedCompany.Count = 1 then begin
          MyCompany := SelectedCompany.Name;
          exit(true);
        end;

        AllowedCompanies.Initialize;

        if SelectedCompany.Get(COMPANYNAME) then
          AllowedCompanies.SetRecord(SelectedCompany);

        AllowedCompanies.LookupMode(true);

        if AllowedCompanies.RunModal = Action::LookupOK then begin
          AllowedCompanies.GetRecord(SelectedCompany);
          if SelectedCompany."Evaluation Company" then
            exit(false);
          MyCompany := SelectedCompany.Name;
          exit(true);
        end;

        exit(false);
    end;
}

