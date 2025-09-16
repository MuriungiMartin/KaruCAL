#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1330 "Instruction Mgt."
{
    Permissions = TableData "My Notifications"=rimd;

    trigger OnRun()
    begin
    end;

    var
        NotAllowedToPostOutsideFiscalYearErr: label 'You cannot post when one or more dates is outside the current fiscal year.';
        WarnUnpostedDocumentsTxt: label 'Warn about unposted documents.';
        WarnUnpostedDocumentsDescriptionTxt: label 'Show warning when you close a document that you have not posted.';
        ConfirmAfterPostingDocumentsTxt: label 'Confirm after posting documents.';
        ConfirmAfterPostingDocumentsDescriptionTxt: label 'Show warning when you post a document where you can choose to view the posted document.';
        ConfirmPostingOutsideFiscalYearTxt: label 'Confirm posting outside the fiscal year.';
        ConfirmPostingOutsideFiscalYearDescriptionTxt: label 'Show warning when you post entries where the posting date is in another fiscal year.';


    procedure ShowConfirm(ConfirmQst: Text;InstructionType: Code[50]): Boolean
    begin
        if GuiAllowed and IsEnabled(InstructionType) then
          exit(Confirm(ConfirmQst));

        exit(true);
    end;


    procedure ConfirmPostingOutsideFiscalYear(ConfirmQst: Text;PostingDate: Date;InstructionType: Code[50]): Boolean
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        if GuiAllowed and not IsEnabled(InstructionType) then begin
          FindNextFYStartingDate(AccountingPeriod);
          if PostingDate >= AccountingPeriod."Starting Date" then begin
            if Confirm(ConfirmQst,false) then
              exit(true);
            Error(NotAllowedToPostOutsideFiscalYearErr);
          end;
        end;
    end;


    procedure DisableMessageForCurrentUser(InstructionType: Code[50])
    var
        UserPreference: Record "User Preference";
    begin
        UserPreference.DisableInstruction(InstructionType);
    end;


    procedure EnableMessageForCurrentUser(InstructionType: Code[50])
    var
        UserPreference: Record "User Preference";
    begin
        UserPreference.EnableInstruction(InstructionType);
    end;


    procedure IsEnabled(InstructionType: Code[50]): Boolean
    var
        UserPreference: Record "User Preference";
    begin
        exit(not UserPreference.Get(UserId,InstructionType));
    end;


    procedure ShowPostedConfirmationMessageCode(): Code[50]
    begin
        exit(UpperCase('ShowPostedConfirmationMessage'));
    end;


    procedure QueryPostOnCloseCode(): Code[50]
    begin
        exit(UpperCase('QueryPostOnClose'));
    end;


    procedure OfficeNoCompanyDlgCode(): Code[50]
    begin
        exit(UpperCase('OfficeNoCompanyDlg'));
    end;


    procedure OfficeUpdateNotificationCode(): Code[50]
    begin
        exit(UpperCase('OfficeUpdateNotification'));
    end;


    procedure PostingOutsideFiscalYearNotAllowedCode(): Code[50]
    begin
        exit(UpperCase('PostingOutsideFiscalYearNotAllowed'));
    end;


    procedure MarkBookingAsInvoicedWarningCode(): Code[50]
    begin
        exit(UpperCase('MarkBookingAaInvoicedWarning'));
    end;

    local procedure FindNextFYStartingDate(var AccountingPeriod: Record "Accounting Period")
    begin
        AccountingPeriod.SetRange(Closed,false);
        AccountingPeriod.SetRange("New Fiscal Year",true);
        AccountingPeriod.FindSet;
        // Try to get starting period of next opened fiscal year
        if AccountingPeriod.Next = 0 then begin
          // If not exists then get the day after the last period of opened fiscal year
          AccountingPeriod.SetRange("New Fiscal Year");
          AccountingPeriod.FindLast;
          AccountingPeriod."Starting Date" := CalcDate('<CM+1D>',AccountingPeriod."Starting Date");
        end;
    end;


    procedure GetClosingUnpostedDocumentNotificationId(): Guid
    begin
        exit('612A2701-4BBB-4C5B-B4C0-629D96B60644');
    end;


    procedure GetOpeningPostedDocumentNotificationId(): Guid
    begin
        exit('0C6ED8F1-7408-4352-8DD1-B9F17332607D');
    end;


    procedure GetPostingOutsideFiscalYeartNotificationId(): Guid
    begin
        exit('F76D6004-5EC5-4DEA-B14D-71B2AEB53ACF');
    end;

    [EventSubscriber(Objecttype::Page, 1518, 'OnInitializingNotificationWithDefaultState', '', false, false)]
    local procedure OnInitializingNotificationWithDefaultState()
    var
        MyNotifications: Record "My Notifications";
    begin
        MyNotifications.InsertDefault(GetClosingUnpostedDocumentNotificationId,
          WarnUnpostedDocumentsTxt,
          WarnUnpostedDocumentsDescriptionTxt,
          IsEnabled(QueryPostOnCloseCode));
        MyNotifications.InsertDefault(GetOpeningPostedDocumentNotificationId,
          ConfirmAfterPostingDocumentsTxt,
          ConfirmAfterPostingDocumentsDescriptionTxt,
          IsEnabled(ShowPostedConfirmationMessageCode));
        MyNotifications.InsertDefault(GetPostingOutsideFiscalYeartNotificationId,
          ConfirmPostingOutsideFiscalYearTxt,
          ConfirmPostingOutsideFiscalYearDescriptionTxt,
          IsEnabled(PostingOutsideFiscalYearNotAllowedCode));
    end;

    [EventSubscriber(ObjectType::Table, Database::"My Notifications", 'OnStateChanged', '', false, false)]
    local procedure OnStateChanged(NotificationId: Guid;NewEnabledState: Boolean)
    begin
        case NotificationId of
          GetClosingUnpostedDocumentNotificationId:
            if NewEnabledState then
              EnableMessageForCurrentUser(QueryPostOnCloseCode)
            else
              DisableMessageForCurrentUser(QueryPostOnCloseCode);
          GetOpeningPostedDocumentNotificationId:
            if NewEnabledState then
              EnableMessageForCurrentUser(ShowPostedConfirmationMessageCode)
            else
              DisableMessageForCurrentUser(ShowPostedConfirmationMessageCode);
          GetPostingOutsideFiscalYeartNotificationId:
            if NewEnabledState then
              EnableMessageForCurrentUser(PostingOutsideFiscalYearNotAllowedCode)
            else
              DisableMessageForCurrentUser(PostingOutsideFiscalYearNotAllowedCode);
        end;
    end;
}

