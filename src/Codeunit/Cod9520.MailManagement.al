#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9520 "Mail Management"
{

    trigger OnRun()
    begin
        if not IsEnabled then
          Error(MailingNotSupportedErr);
        if not DoSend then
          Error(MailWasNotSendErr);
    end;

    var
        TempEmailItem: Record "Email Item" temporary;
        SMTPMail: Codeunit "SMTP Mail";
        FileManagement: Codeunit "File Management";
        InvalidEmailAddressErr: label 'The email address "%1" is not valid.';
        DoEdit: Boolean;
        HideMailDialog: Boolean;
        Cancelled: Boolean;
        MailSent: Boolean;
        MailingNotSupportedErr: label 'The required email is not supported.';
        MailWasNotSendErr: label 'The email was not sent.';
        FromAddressWasNotFoundErr: label 'An email from address was not found. Contact an administrator.';
        SaveFileDialogTitleMsg: label 'Save PDF file';
        SaveFileDialogFilterMsg: label 'PDF Files (*.pdf)|*.pdf';
        OutlookSupported: Boolean;
        SMTPSupported: Boolean;
        CannotSendMailThenDownloadQst: label 'Do you want to download the attachment?';
        CannotSendMailThenDownloadErr: label 'You cannot send the email.\Verify that the email settings are correct.';
        OutlookNotAvailableContinueEditQst: label 'Microsoft Outlook is not available.\\Do you want to continue to edit the email?';
        HideSMTPError: Boolean;
        EmailAttachmentTxt: label 'Email.html', Locked=true;

    local procedure RunMailDialog(): Boolean
    var
        EmailDialog: Page "Email Dialog";
    begin
        EmailDialog.SetValues(TempEmailItem,OutlookSupported,SMTPSupported);

        if not (EmailDialog.RunModal = Action::OK) then begin
          Cancelled := true;
          exit(false);
        end;
        EmailDialog.GetRecord(TempEmailItem);
        DoEdit := EmailDialog.GetDoEdit;
        exit(true);
    end;

    local procedure SendViaSMTP(): Boolean
    begin
        with TempEmailItem do begin
          SMTPMail.CreateMessage("From Name","From Address","Send to",Subject,GetBodyText,not "Plaintext Formatted");
          SMTPMail.AddAttachment("Attachment File Path","Attachment Name");
          if "Send CC" <> '' then
            SMTPMail.AddCC("Send CC");
          if "Send BCC" <> '' then
            SMTPMail.AddBCC("Send BCC");
        end;
        MailSent := SMTPMail.TrySend;
        if not MailSent and not HideSMTPError then
          Error(SMTPMail.GetLastSendMailErrorText);
        exit(MailSent);
    end;


    procedure InitializeFrom(NewHideMailDialog: Boolean;NewHideSMTPError: Boolean)
    begin
        HideMailDialog := NewHideMailDialog;
        HideSMTPError := NewHideSMTPError;
    end;

    local procedure SendMailOnWinClient(): Boolean
    var
        Mail: Codeunit Mail;
        FileManagement: Codeunit "File Management";
        ClientAttachmentFilePath: Text;
        ClientAttachmentFullName: Text;
        BodyText: Text;
    begin
        if Mail.TryInitializeOutlook then
          with TempEmailItem do begin
            if "Attachment File Path" <> '' then begin
              ClientAttachmentFilePath := DownloadPdfOnClient("Attachment File Path");
              ClientAttachmentFullName := FileManagement.MoveAndRenameClientFile(ClientAttachmentFilePath,"Attachment Name",'');
            end;
            BodyText := ImageBase64ToUrl(GetBodyText);
            if Mail.NewMessageAsync("Send to","Send CC","Send BCC",Subject,BodyText,ClientAttachmentFullName,not HideMailDialog) then begin
              FileManagement.DeleteClientFile(ClientAttachmentFullName);
              MailSent := true;
              exit(true)
            end;
          end;
        exit(false);
    end;

    local procedure DownloadPdfOnClient(ServerPdfFilePath: Text): Text
    var
        FileManagement: Codeunit "File Management";
        ClientPdfFilePath: Text;
    begin
        ClientPdfFilePath := FileManagement.DownloadTempFile(ServerPdfFilePath);
        Erase(ServerPdfFilePath);
        exit(ClientPdfFilePath);
    end;


    procedure CheckValidEmailAddresses(Recipients: Text)
    var
        TmpRecipients: Text;
    begin
        if Recipients = '' then
          Error(InvalidEmailAddressErr,Recipients);

        TmpRecipients := DelChr(Recipients,'<>',';');
        while StrPos(TmpRecipients,';') > 1 do begin
          CheckValidEmailAddress(CopyStr(TmpRecipients,1,StrPos(TmpRecipients,';') - 1));
          TmpRecipients := CopyStr(TmpRecipients,StrPos(TmpRecipients,';') + 1);
        end;
        CheckValidEmailAddress(TmpRecipients);
    end;


    procedure CheckValidEmailAddress(EmailAddress: Text)
    var
        i: Integer;
        NoOfAtSigns: Integer;
    begin
        EmailAddress := DelChr(EmailAddress,'<>');

        if EmailAddress = '' then
          Error(InvalidEmailAddressErr,EmailAddress);

        if (EmailAddress[1] = '@') or (EmailAddress[StrLen(EmailAddress)] = '@') then
          Error(InvalidEmailAddressErr,EmailAddress);

        for i := 1 to StrLen(EmailAddress) do begin
          if EmailAddress[i] = '@' then
            NoOfAtSigns := NoOfAtSigns + 1
          else
            if EmailAddress[i] = ' ' then
              Error(InvalidEmailAddressErr,EmailAddress);
        end;

        if NoOfAtSigns <> 1 then
          Error(InvalidEmailAddressErr,EmailAddress);
    end;


    procedure IsSMTPEnabled(): Boolean
    begin
        exit(SMTPMail.IsEnabled);
    end;


    procedure IsEnabled(): Boolean
    begin
        OutlookSupported := false;
        SMTPSupported := false;
        if IsSMTPEnabled then
          SMTPSupported := true;

        if not FileManagement.CanRunDotNetOnClient then
          exit(SMTPSupported);

        // Assume Outlook is supported - a false check takes long time.
        OutlookSupported := true;
        exit(true);
    end;


    procedure IsCancelled(): Boolean
    begin
        exit(Cancelled);
    end;


    procedure IsSent(): Boolean
    begin
        exit(MailSent);
    end;


    procedure Send(ParmEmailItem: Record "Email Item"): Boolean
    begin
        TempEmailItem := ParmEmailItem;
        QualifyFromAddress;
        MailSent := false;
        exit(DoSend);
    end;

    local procedure DoSend(): Boolean
    begin
        Cancelled := true;
        if not HideMailDialog then begin
          if RunMailDialog then
            Cancelled := false
          else
            exit(true);
          if OutlookSupported then
            if DoEdit then begin
              if SendMailOnWinClient then
                exit(true);
              OutlookSupported := false;
              if not SMTPSupported then
                exit(false);
              if Confirm(OutlookNotAvailableContinueEditQst) then
                exit(DoSend);
            end
        end;
        if SMTPSupported then
          exit(SendViaSMTP);

        exit(false);
    end;

    local procedure QualifyFromAddress()
    var
        TempPossibleEmailNameValueBuffer: Record "Name/Value Buffer" temporary;
        MailForEmails: Codeunit Mail;
    begin
        if TempEmailItem."From Address" <> '' then
          exit;

        MailForEmails.CollectCurrentUserEmailAddresses(TempPossibleEmailNameValueBuffer);
        if SMTPSupported then begin
          if IsConfiguredForO365 then
            if AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'SMTPSetup') then
              exit;

          if AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'UserSetup') then
            exit;
          if AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'AuthEmail') then
            exit;
          if AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'AD') then
            exit;
          if AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'SMTPSetup') then
            exit;
        end;
        if TempPossibleEmailNameValueBuffer.IsEmpty then begin
          if FileManagement.IsWebClient then
            Error(FromAddressWasNotFoundErr);
          TempEmailItem."From Address" := '';
          exit;
        end;

        if AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'') then
          exit;
    end;

    local procedure AssignFromAddressIfExist(var TempPossibleEmailNameValueBuffer: Record "Name/Value Buffer" temporary;FilteredName: Text): Boolean
    begin
        if FilteredName <> '' then
          TempPossibleEmailNameValueBuffer.SetFilter(Name,FilteredName);
        if not TempPossibleEmailNameValueBuffer.IsEmpty then begin
          TempPossibleEmailNameValueBuffer.FindFirst;
          if TempPossibleEmailNameValueBuffer.Value <> '' then begin
            TempEmailItem."From Address" := TempPossibleEmailNameValueBuffer.Value;
            exit(true);
          end;
        end;

        TempPossibleEmailNameValueBuffer.Reset;
        exit(false);
    end;


    procedure SendMailOrDownload(TempEmailItem: Record "Email Item" temporary;HideMailDialog: Boolean)
    var
        MailManagement: Codeunit "Mail Management";
    begin
        MailManagement.InitializeFrom(HideMailDialog,CurrentClientType <> Clienttype::Background);
        if MailManagement.IsEnabled then
          if MailManagement.Send(TempEmailItem) then begin
            MailSent := MailManagement.IsSent;
            exit;
          end;

        if not GuiAllowed then
          Error(CannotSendMailThenDownloadErr);

        if not Confirm(StrSubstNo('%1\\%2',CannotSendMailThenDownloadErr,CannotSendMailThenDownloadQst)) then
          exit;

        DownloadPdfAttachment(TempEmailItem);
    end;


    procedure DownloadPdfAttachment(TempEmailItem: Record "Email Item" temporary)
    var
        FileManagement: Codeunit "File Management";
    begin
        with TempEmailItem do
          if "Attachment File Path" <> '' then
            FileManagement.DownloadHandler("Attachment File Path",SaveFileDialogTitleMsg,'',SaveFileDialogFilterMsg,"Attachment Name")
          else
            if "Body File Path" <> '' then
              FileManagement.DownloadHandler("Body File Path",SaveFileDialogTitleMsg,'',SaveFileDialogFilterMsg,EmailAttachmentTxt);
    end;


    procedure ImageBase64ToUrl(BodyText: Text): Text
    var
        Regex: dotnet Regex;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
        SearchText: Text;
        Base64: Text;
        MediaId: Guid;
    begin
        SearchText := '(.*<img src=\")data:image\/[a-z]+;base64,([a-zA-Z0-9\/+=]+)(\".*)';
        Regex := Regex.Regex(SearchText);
        while Regex.IsMatch(BodyText) do begin
          Base64 := Regex.Replace(BodyText,'$2',1);
          MemoryStream := MemoryStream.MemoryStream(Convert.FromBase64String(Base64));
          MediaId := IMPORTSTREAMWITHURLACCESS(MemoryStream,CreateGuid,1);
          BodyText := Regex.Replace(BodyText,'$1' + GetDocumentUrl(MediaId) + '$3',1);
        end;
        exit(BodyText);
    end;

    local procedure IsConfiguredForO365(): Boolean
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
    begin
        SMTPMailSetup.Get;
        exit(SMTPMail.IsOffice365Setup(SMTPMailSetup));
    end;
}

