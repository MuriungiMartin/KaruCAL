#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 400 "SMTP Mail"
{
    Permissions = TableData "SMTP Mail Setup"=r;

    trigger OnRun()
    begin
    end;

    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        Mail: dotnet SmtpMessage;
        Text002: label 'Attachment %1 does not exist or can not be accessed from the program.', Comment='%1=file name';
        Text003: label 'The mail system returned the following error: "%1".', Comment='%1=an error message';
        SendResult: Text;


    procedure CreateMessage(SenderName: Text;SenderAddress: Text;Recipients: Text;Subject: Text;Body: Text;HtmlFormatted: Boolean)
    begin
        if Recipients <> '' then
          CheckValidEmailAddresses(Recipients);
        CheckValidEmailAddresses(SenderAddress);
        SMTPMailSetup.Get;
        SMTPMailSetup.TestField("SMTP Server");
        if not IsNull(Mail) then begin
          Mail.Dispose;
          Clear(Mail);
        end;
        SendResult := '';
        Mail := Mail.SmtpMessage;
        Mail.FromName := SenderName;
        Mail.FromAddress := SenderAddress;
        Mail."To" := Recipients;
        Mail.Subject := Subject;
        Mail.Body := Body;
        Mail.HtmlFormatted := HtmlFormatted;

        if HtmlFormatted then
          Mail.ConvertBase64ImagesToContentId;
    end;


    procedure TrySend(): Boolean
    var
        Password: Text[250];
    begin
        SendResult := '';
        Password := SMTPMailSetup.GetPassword;
        with SMTPMailSetup do
          SendResult :=
            Mail.Send(
              "SMTP Server",
              "SMTP Server Port",
              Authentication <> Authentication::Anonymous,
              "User ID",
              Password,
              "Secure Connection");
        Mail.Dispose;
        Clear(Mail);

        exit(SendResult = '');
    end;


    procedure Send()
    begin
        if not TrySend then
         exit;
        // ERROR(Text003,SendResult);
    end;


    procedure AddRecipients(Recipients: Text)
    var
        Result: Text;
    begin
        CheckValidEmailAddresses(Recipients);
        Result := Mail.AddRecipients(Recipients);
        if Result <> '' then
          Error(Text003,Result);
    end;


    procedure AddCC(Recipients: Text)
    var
        Result: Text;
    begin
        CheckValidEmailAddresses(Recipients);
        Result := Mail.AddCC(Recipients);
        if Result <> '' then
          Error(Text003,Result);
    end;


    procedure AddBCC(Recipients: Text)
    var
        Result: Text;
    begin
        CheckValidEmailAddresses(Recipients);
        Result := Mail.AddBCC(Recipients);
        if Result <> '' then
          Error(Text003,Result);
    end;


    procedure AppendBody(BodyPart: Text)
    var
        Result: Text;
    begin
        Result := Mail.AppendBody(BodyPart);
        if Result <> '' then
          Error(Text003,Result);
    end;


    procedure AddAttachment(Attachment: Text;FileName: Text)
    var
        FileManagement: Codeunit "File Management";
        Result: Text;
    begin
        if Attachment = '' then
          exit;
        if not Exists(Attachment) then
          Error(Text002,Attachment);

        FileName := FileManagement.StripNotsupportChrInFileName(FileName);
        FileName := DelChr(FileName,'=',';'); // Used for splitting multiple file names in Mail .NET component

        Result := Mail.AddAttachmentWithName(Attachment,FileName);

        if Result <> '' then
          Error(Text003,Result);
    end;


    procedure AddAttachmentStream(AttachmentStream: InStream;AttachmentName: Text)
    var
        FileManagement: Codeunit "File Management";
    begin
        AttachmentName := FileManagement.StripNotsupportChrInFileName(AttachmentName);

        Mail.AddAttachment(AttachmentStream,AttachmentName);
    end;


    procedure CheckValidEmailAddresses(Recipients: Text)
    var
        MailManagement: Codeunit "Mail Management";
    begin
        MailManagement.CheckValidEmailAddresses(Recipients);
    end;


    procedure GetLastSendMailErrorText(): Text
    begin
        exit(SendResult);
    end;


    procedure GetSMTPMessage(var SMTPMessage: dotnet SmtpMessage)
    begin
        SMTPMessage := Mail;
    end;


    procedure IsEnabled(): Boolean
    begin
        if SMTPMailSetup.Find then
          exit(not (SMTPMailSetup."SMTP Server" = ''));

        exit(false);
    end;


    procedure ApplyOffice365Smtp(var SMTPMailSetupConfig: Record "SMTP Mail Setup")
    begin
        // This might be changed by the Microsoft Office 365 team.
        // Current source: http://technet.microsoft.com/library/dn554323.aspx
        SMTPMailSetupConfig."SMTP Server" := GetO365SmtpServer;
        SMTPMailSetupConfig."SMTP Server Port" := GetO365SmtpPort;
        SMTPMailSetupConfig.Authentication := GetO365SmtpAuthType;
        SMTPMailSetupConfig."Secure Connection" := true;
    end;


    procedure IsOffice365Setup(var SMTPMailSetupConfig: Record "SMTP Mail Setup"): Boolean
    begin
        if SMTPMailSetupConfig."SMTP Server" <> GetO365SmtpServer then
          exit(false);

        if SMTPMailSetupConfig."SMTP Server Port" <> GetO365SmtpPort then
          exit(false);

        if SMTPMailSetupConfig.Authentication <> GetO365SmtpAuthType then
          exit(false);

        if SMTPMailSetupConfig."Secure Connection" <> true then
          exit(false);

        exit(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Connection", 'OnRegisterServiceConnection', '', false, false)]

    procedure HandleSMTPRegisterServiceConnection(var ServiceConnection: Record "Service Connection")
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        RecRef: RecordRef;
    begin
        if not SMTPMailSetup.Get then begin
          if not SMTPMailSetup.WritePermission then
            exit;
          SMTPMailSetup.Init;
          SMTPMailSetup.Insert;
        end;

        RecRef.GetTable(SMTPMailSetup);

        ServiceConnection.Status := ServiceConnection.Status::Enabled;
        if SMTPMailSetup."SMTP Server" = '' then
          ServiceConnection.Status := ServiceConnection.Status::Disabled;

        with SMTPMailSetup do
          ServiceConnection.InsertServiceConnection(
            ServiceConnection,RecRef.RecordId,TableCaption,'',Page::"SMTP Mail Setup");
    end;


    procedure GetBody(): Text
    begin
        exit(Mail.Body);
    end;

    local procedure GetO365SmtpServer(): Text[250]
    begin
        exit('smtp.office365.com')
    end;

    local procedure GetO365SmtpPort(): Integer
    begin
        exit(587);
    end;

    local procedure GetO365SmtpAuthType(): Integer
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
    begin
        exit(SMTPMailSetup.Authentication::Basic);
    end;
}

