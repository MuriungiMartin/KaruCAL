#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1509 "Notification Entry Dispatcher"
{
    Permissions = TableData "User Setup"=r,
                  TableData "Notification Entry"=rimd,
                  TableData "Sent Notification Entry"=rimd,
                  TableData "Email Item"=rimd;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if "Parameter String" = '' then
          DispatchInstantNotifications
        else
          DispatchNotificationTypeForUser("Parameter String");
    end;

    var
        NotificationManagement: Codeunit "Notification Management";
        NotificationMailSubjectTxt: label 'Notification overview';
        HtmlBodyFilePath: Text;

    local procedure DispatchInstantNotifications()
    var
        UserSetup: Record "User Setup";
        UserIDsbyNotificationType: Query "User IDs by Notification Type";
    begin
        UserIDsbyNotificationType.Open;
        while UserIDsbyNotificationType.Read do begin
          UserSetup.Get(UserIDsbyNotificationType.Recipient_User_ID);
          if ScheduledInstantly(UserSetup."User ID",UserIDsbyNotificationType.Type) then
            DispatchForNotificationType(UserIDsbyNotificationType.Type,UserSetup);
        end;
    end;

    local procedure DispatchNotificationTypeForUser(Parameter: Text)
    var
        UserSetup: Record "User Setup";
        NotificationEntry: Record "Notification Entry";
    begin
        NotificationEntry.SetView(Parameter);
        UserSetup.Get(NotificationEntry.GetRangemax("Recipient User ID"));
        DispatchForNotificationType(NotificationEntry.GetRangemax(Type),UserSetup);
    end;

    local procedure DispatchForNotificationType(NotificationType: Option "New Record",Approval,Overdue;UserSetup: Record "User Setup")
    var
        NotificationEntry: Record "Notification Entry";
        NotificationSetup: Record "Notification Setup";
    begin
        NotificationEntry.SetRange("Recipient User ID",UserSetup."User ID");
        NotificationEntry.SetRange(Type,NotificationType);

        DeleteOutdatedApprovalNotificationEntires(NotificationEntry);

        if not NotificationEntry.FindFirst then
          exit;

        FilterToActiveNotificationEntries(NotificationEntry);

        NotificationSetup.GetNotificationSetup(NotificationType);

        case NotificationSetup."Notification Method" of
          NotificationSetup."notification method"::Email:
            CreateMailAndDispatch(NotificationEntry,UserSetup."E-Mail");
          NotificationSetup."notification method"::Note:
            CreateNoteAndDispatch(NotificationEntry);
        end;
    end;

    local procedure ScheduledInstantly(RecipientUserID: Code[50];NotificationType: Option): Boolean
    var
        NotificationSchedule: Record "Notification Schedule";
    begin
        if not NotificationSchedule.Get(RecipientUserID,NotificationType) then
          exit(true); // No rules are set up, send immediately

        exit(NotificationSchedule.Recurrence = NotificationSchedule.Recurrence::Instantly);
    end;

    local procedure CreateMailAndDispatch(var NotificationEntry: Record "Notification Entry";Email: Text)
    var
        NotificationSetup: Record "Notification Setup";
        DocumentMailing: Codeunit "Document-Mailing";
        BodyText: Text;
    begin
        if GetHTMLBodyText(NotificationEntry,BodyText) then
          if DocumentMailing.EmailFileWithSubject('','',HtmlBodyFilePath,NotificationMailSubjectTxt,Email,true) then
            NotificationManagement.MoveNotificationEntryToSentNotificationEntries(
              NotificationEntry,BodyText,true,NotificationSetup."notification method"::Email)
          else begin
            NotificationEntry.Validate("Error Message",GetLastErrorText);
            ClearLastError;
            NotificationEntry.Modify(true);
          end;
    end;

    local procedure CreateNoteAndDispatch(var NotificationEntry: Record "Notification Entry")
    var
        NotificationSetup: Record "Notification Setup";
        BodyText: Text;
    begin
        repeat
          if AddNote(NotificationEntry,BodyText) then
            NotificationManagement.MoveNotificationEntryToSentNotificationEntries(
              NotificationEntry,BodyText,false,
              NotificationSetup."notification method"::Note);
        until NotificationEntry.Next = 0;
    end;

    local procedure AddNote(var NotificationEntry: Record "Notification Entry";var Body: Text): Boolean
    var
        RecordLink: Record "Record Link";
        DataTypeManagement: Codeunit "Data Type Management";
        PageManagement: Codeunit "Page Management";
        TypeHelper: Codeunit "Type Helper";
        RecRef: RecordRef;
        RecRefLink: RecordRef;
        Link: Text;
    begin
        DataTypeManagement.GetRecordRef(NotificationEntry."Triggered By Record",RecRef);
        if not RecRef.HasFilter then
          RecRef.SetRecfilter;

        with RecordLink do begin
          Init;
          "Link ID" := 0;
          GetTargetRecRef(NotificationEntry,RecRefLink);
          "Record ID" := RecRefLink.RecordId;
          Link := GetUrl(DefaultClientType,COMPANYNAME,Objecttype::Page,PageManagement.GetPageID(RecRefLink),RecRefLink,true);
          URL1 := CopyStr(Link,1,MaxStrLen(URL1));
          if StrLen(Link) > MaxStrLen(URL1) then
            URL2 := CopyStr(Link,MaxStrLen(URL1) + 1,MaxStrLen(URL2));
          Description := CopyStr(Format(NotificationEntry."Triggered By Record"),1,250);
          Type := Type::Note;
          CreateNoteBody(NotificationEntry,Body);
          TypeHelper.WriteRecordLinkNote(RecordLink,Body);
          Created := CurrentDatetime;
          "User ID" := NotificationEntry."Created By";
          Company := COMPANYNAME;
          Notify := true;
          "To User ID" := NotificationEntry."Recipient User ID";
          exit(Insert(true));
        end;

        exit(false);
    end;

    local procedure FilterToActiveNotificationEntries(var NotificationEntry: Record "Notification Entry")
    begin
        repeat
          NotificationEntry.Mark(true);
        until NotificationEntry.Next = 0;
        NotificationEntry.MarkedOnly(true);
        NotificationEntry.FindSet;
    end;

    local procedure ConvertHtmlFileToText(HtmlBodyFilePath: Text;var BodyText: Text)
    var
        TempBlob: Record TempBlob temporary;
        FileManagement: Codeunit "File Management";
        BlobInStream: InStream;
    begin
        TempBlob.Init;
        FileManagement.BLOBImportFromServerFile(TempBlob,HtmlBodyFilePath);
        TempBlob.Blob.CreateInstream(BlobInStream);
        BlobInStream.ReadText(BodyText);
    end;

    local procedure CreateNoteBody(var NotificationEntry: Record "Notification Entry";var Body: Text)
    var
        RecRef: RecordRef;
        DocumentType: Text;
        DocumentNo: Text;
        DocumentName: Text;
        ActionText: Text;
    begin
        GetTargetRecRef(NotificationEntry,RecRef);
        NotificationManagement.GetDocumentTypeAndNumber(RecRef,DocumentType,DocumentNo);
        DocumentName := DocumentType + ' ' + DocumentNo;
        ActionText := NotificationManagement.GetActionTextFor(NotificationEntry);
        Body := DocumentName + ' ' + ActionText;
    end;


    procedure GetHTMLBodyText(var NotificationEntry: Record "Notification Entry";var BodyTextOut: Text): Boolean
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        FileManagement: Codeunit "File Management";
    begin
        HtmlBodyFilePath := FileManagement.ServerTempFileName('html');
        ReportLayoutSelection.SetTempLayoutSelected('');
        if not Report.SaveAsHtml(Report::"Notification Email",HtmlBodyFilePath,NotificationEntry) then begin
          NotificationEntry.Validate("Error Message",GetLastErrorText);
          ClearLastError;
          NotificationEntry.Modify(true);
          exit(false);
        end;

        ConvertHtmlFileToText(HtmlBodyFilePath,BodyTextOut);
        exit(true);
    end;

    local procedure GetTargetRecRef(var NotificationEntry: Record "Notification Entry";var TargetRecRefOut: RecordRef)
    var
        ApprovalEntry: Record "Approval Entry";
        OverdueApprovalEntry: Record "Overdue Approval Entry";
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
    begin
        DataTypeManagement.GetRecordRef(NotificationEntry."Triggered By Record",RecRef);

        case NotificationEntry.Type of
          NotificationEntry.Type::"New Record":
            TargetRecRefOut := RecRef;
          NotificationEntry.Type::Approval:
            begin
              RecRef.SetTable(ApprovalEntry);
              TargetRecRefOut.Get(ApprovalEntry.CanCurrentUserEdit);
            end;
          NotificationEntry.Type::Overdue:
            begin
              RecRef.SetTable(OverdueApprovalEntry);
              TargetRecRefOut.Get(OverdueApprovalEntry."Record ID to Approve");
            end;
        end;
    end;

    local procedure DeleteOutdatedApprovalNotificationEntires(var NotificationEntry: Record "Notification Entry")
    begin
        if NotificationEntry.FindFirst then
          repeat
            if ApprovalNotificationEntryIsOutdated(NotificationEntry) then
              NotificationEntry.Delete;
          until NotificationEntry.Next = 0;
    end;

    local procedure ApprovalNotificationEntryIsOutdated(var NotificationEntry: Record "Notification Entry"): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        OverdueApprovalEntry: Record "Overdue Approval Entry";
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
    begin
        DataTypeManagement.GetRecordRef(NotificationEntry."Triggered By Record",RecRef);

        case NotificationEntry.Type of
          NotificationEntry.Type::Approval:
            begin
              RecRef.SetTable(ApprovalEntry);
              if not RecRef.Get(ApprovalEntry.CanCurrentUserEdit) then
                exit(true);
            end;
          NotificationEntry.Type::Overdue:
            begin
              RecRef.SetTable(OverdueApprovalEntry);
              if not RecRef.Get(OverdueApprovalEntry."Record ID to Approve") then
                exit(true);
            end;
        end;
    end;
}

