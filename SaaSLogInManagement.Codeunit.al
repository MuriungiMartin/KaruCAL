#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50 "SaaS Log In Management"
{

    trigger OnRun()
    begin
    end;

    var
        TermsAndConditionsDescriptionTxt: label 'Rebranding from Madeira to Dynamics 365 Financials';
        DateFilterCalc: Codeunit "DateFilter-Calc";
        SettingUpMsg: label 'Please wait while we are setting up your new company.';
        NoPermissionToEnterTrialErr: label 'In order to open %1, your company must start a trial. You must be an administrator to enter the trial period.', Comment='%1 = Company Name';
        MyCompanyTxt: label 'My Company';

    local procedure SetTenantLicenseState()
    var
        TenantLicenseState: Record "Tenant License State";
        Company: Record Company;
        PermissionManager: Codeunit "Permission Manager";
    begin
        if not PermissionManager.SoftwareAsAService then
          exit;

        if not TenantLicenseState.FindLast then begin
          TenantLicenseState.Init;
          TenantLicenseState."Start Date" := DateFilterCalc.ConvertToUtcDateTime(CurrentDatetime);
          TenantLicenseState.State := TenantLicenseState.State::Evaluation;
          TenantLicenseState."User Security ID" := UserSecurityId;
          TenantLicenseState.Insert(true);
        end;

        if TenantLicenseState.State <> TenantLicenseState.State::Evaluation then
          exit;

        Company.Get(COMPANYNAME);
        if not Company."Evaluation Company" then
          StartTrial;
    end;

    local procedure ShowRebrandingDialog()
    var
        TenantLicenseState: Record "Tenant License State";
        TermsAndConditions: Record "Terms And Conditions";
        TermsAndConditionsState: Record "Terms And Conditions State";
        Company: Record Company;
        PermissionManager: Codeunit "Permission Manager";
        MadeiraRebrandingDialog: Page "Designer Diagnostics ListPart";
    begin
        if not PermissionManager.SoftwareAsAService then
          exit;

        if not TermsAndConditions.Get('MADEIRAREBRANDING') then begin
          TermsAndConditions.Init;
          TermsAndConditions."No." := 'MADEIRAREBRANDING';
          TermsAndConditions.Description := TermsAndConditionsDescriptionTxt;
          TermsAndConditions."Valid From" := 20160111D;
          TermsAndConditions.Insert;
        end;

        if not TermsAndConditionsState.Get(TermsAndConditions."No.",UserId) then begin
          TermsAndConditionsState.Init;
          TermsAndConditionsState."Terms And Conditions Code" := TermsAndConditions."No.";
          TermsAndConditionsState."User ID" := UserId;
          TermsAndConditionsState.Insert;
        end;

        if TermsAndConditionsState.Accepted then
          exit;

        TenantLicenseState.FindFirst; // Find the first tenant license state, which is the earliest state
        if not UserHasLoggedOnPriorToFirstLicenseState(TenantLicenseState."Start Date") then
          exit;

        Commit;

        Company.Get(COMPANYNAME);
        MadeiraRebrandingDialog.SetProductionCompanyOpened(not Company."Evaluation Company");
        MadeiraRebrandingDialog.RunModal;

        TermsAndConditionsState.Accepted := true;
        TermsAndConditionsState."Date Accepted" := DateFilterCalc.ConvertToUtcDateTime(CurrentDatetime);
        TermsAndConditionsState.Modify;
    end;

    local procedure UserHasLoggedOnPriorToFirstLicenseState(StartDate: DateTime): Boolean
    var
        SessionEvent: Record "Session Event";
    begin
        // The current user has logged on to the system one day prior to the earliest tenant license state (Project "Madeira" user).
        SessionEvent.SetRange("User SID",UserSecurityId);
        SessionEvent.SetFilter("Session ID",'<>%1',SessionId);
        SessionEvent.SetRange("Event Type",SessionEvent."event type"::Logon);
        SessionEvent.SetFilter("Client Type",'<>%1',SessionEvent."client type"::Background);
        SessionEvent.SetFilter("Event Datetime",'<%1',StartDate - 60 * 60 * 24 * 1000); // Last login must be more than a day ago

        exit(not SessionEvent.IsEmpty);
    end;

    local procedure ShowTermsAndConditionsAndSetTenantLicenseState(Company: Record Company)
    var
        TenantLicenseState: Record "Tenant License State";
        PermissionManager: Codeunit "Permission Manager";
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
        ThirtyDayTrialDialog: Page "Thirty Day Trial Dialog";
    begin
        if not PermissionManager.SoftwareAsAService then
          exit;

        if Company."Evaluation Company" then
          exit;

        if TenantLicenseState.IsEmpty then begin
          TenantLicenseState.Init;
          TenantLicenseState."Start Date" := DateFilterCalc.ConvertToUtcDateTime(CurrentDatetime);
          TenantLicenseState.State := TenantLicenseState.State::Evaluation;
          TenantLicenseState."User Security ID" := UserSecurityId;
          TenantLicenseState.Insert(true);
          Commit;
        end;

        TenantLicenseState.FindLast;
        if TenantLicenseState.State <> TenantLicenseState.State::Evaluation then
          exit;

        // Verify, that the user has company setup rights
        if not Company.WritePermission then
          Error(NoPermissionToEnterTrialErr,Company.Name);

        ThirtyDayTrialDialog.SetMyCompany(MyCompanyTxt);
        ThirtyDayTrialDialog.RunModal;

        if not ThirtyDayTrialDialog.Confirmed then begin
          if RoleCenterNotificationMgt.IsEvaluationNotificationClicked then
            RoleCenterNotificationMgt.ShowEvaluationNotification;
          Error('');
        end;

        StartTrial;
    end;

    local procedure StartTrial()
    var
        TenantLicenseState: Record "Tenant License State";
    begin
        TenantLicenseState.Init;
        TenantLicenseState."Start Date" := DateFilterCalc.ConvertToUtcDateTime(CurrentDatetime) + 1000; // Move time by 1 second to avoid overlap with previous state
        TenantLicenseState.State := TenantLicenseState.State::Trial;
        TenantLicenseState."User Security ID" := UserSecurityId;
        TenantLicenseState.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"User Personalization", 'OnBeforeValidateEvent', 'Company', false, false)]
    local procedure OnBeforeUserPersonalizationCompanyChange(var Rec: Record "User Personalization";var xRec: Record "User Personalization";CurrFieldNo: Integer)
    var
        Company: Record Company;
    begin
        if Company.Get(Rec.Company) then
          ShowTermsAndConditionsAndSetTenantLicenseState(Company);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnAfterLogInStart', '', false, false)]
    local procedure OnAfterLogInStart()
    begin
        SetTenantLicenseState;
        ShowRebrandingDialog;
    end;

    [EventSubscriber(ObjectType::Table, Database::"User Personalization", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterUserPersonalizationModify(var Rec: Record "User Personalization";var xRec: Record "User Personalization";RunTrigger: Boolean)
    var
        Company: Record Company;
        PendingCompanyRename: Record UnknownRecord9192;
        CompanyInformation: Record "Company Information";
        PermissionManager: Codeunit "Permission Manager";
        Window: Dialog;
    begin
        if not PermissionManager.SoftwareAsAService then
          exit;

        if not PendingCompanyRename.Get(Rec.Company) then
          exit;

        Window.Open(SettingUpMsg);

        if CompanyInformation.ChangeCompany(Rec.Company) then begin
          CompanyInformation.Get;
          CompanyInformation.Validate(Name,PendingCompanyRename."New Company Name");
          CompanyInformation.Modify;
        end;

        Company.Get(PendingCompanyRename."Current Company Name");
        Company.Rename(PendingCompanyRename."New Company Name");

        PendingCompanyRename.Delete;

        Window.Close;
    end;
}

