#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5321 "Exchange Web Services Server"
{

    trigger OnRun()
    begin
    end;

    var
        Service: dotnet ExchangeServiceWrapper;
        ProdEndpointTxt: label 'https://outlook.office365.com/EWS/Exchange.asmx', Locked=true;
        PPEEndpointTxt: label 'https://edgesdf.outlook.com/EWS/Exchange.asmx', Locked=true;
        ExpiredTokenErr: label 'Trying to reconnect. Please close and reopen the add-in.';
        TestMessageIdTxt: label '1234', Locked=true;


    procedure Initialize(AutodiscoveryEmail: Text[250];ServiceUri: Text;Credentials: dotnet ExchangeCredentials;Rediscover: Boolean) Result: Boolean
    var
        ServiceFactory: dotnet ServiceWrapperFactory;
    begin
        if IsNull(Service) then
          Service := ServiceFactory.CreateServiceWrapper2013;

        if (ServiceUri = '') and not Rediscover then
          ServiceUri := GetEndpoint;
        Service.ExchangeServiceUrl := ServiceUri;

        if not IsNull(Credentials) then
          Service.SetNetworkCredential(Credentials);

        if (Service.ExchangeServiceUrl = '') or Rediscover then
          Result := Service.AutodiscoverServiceUrl(AutodiscoveryEmail)
        else
          Result := true;
    end;


    procedure InitializeWithCertificate(ApplicationID: Guid;Thumbprint: Text[40];AuthenticationEndpoint: Text[250];ExchangeEndpoint: Text[250];ResourceUri: Text[250])
    var
        ServiceFactory: dotnet ServiceWrapperFactory;
    begin
        Service := ServiceFactory.CreateServiceWrapperWithCertificate(ApplicationID,Thumbprint,AuthenticationEndpoint,ResourceUri);
        Service.ExchangeServiceUrl := ExchangeEndpoint;
    end;


    procedure InitializeWithOAuthToken(Token: Text;ExchangeEndpoint: Text)
    var
        AzureADMgt: Codeunit "Azure AD Mgt.";
    begin
        if ExchangeEndpoint = '' then
          ExchangeEndpoint := GetEndpoint;

        AzureADMgt.CreateExchangeServiceWrapperWithToken(Token,Service);
        Service.ExchangeServiceUrl := ExchangeEndpoint;
        if IsPPE then
          if not ValidEndpoint then
            Service.ExchangeServiceUrl := ProdEndpoint;
    end;

    [TryFunction]

    procedure ValidCredentials()
    var
        AzureADAuthFlow: Codeunit "Azure AD Auth Flow";
    begin
        if AzureADAuthFlow.CanHandle then
          if not Service.ValidateCredentials then
            Error('');
    end;


    procedure SetImpersonatedIdentity(Email: Text[250])
    begin
        Service.SetImpersonatedIdentity(Email);
    end;


    procedure InstallApp(ManifestPath: InStream)
    begin
        Service.InstallApp(ManifestPath);
    end;


    procedure CreateAppointment(var Appointment: dotnet IAppointment)
    begin
        Appointment := Service.CreateAppointment;
    end;

    [TryFunction]

    procedure SendEmailMessageWithAttachment(Subject: Text;RecipientAddress: Text;BodyHTML: Text;AttachmentPath: Text;SenderAddress: Text)
    begin
        Service.SendMessageAndSaveToSentItems(Subject,RecipientAddress,BodyHTML,AttachmentPath,SenderAddress,'');
    end;


    procedure SaveEmailToInbox(EmailMessage: Text)
    begin
        Service.SaveEmlMessageToInbox(EmailMessage);
    end;


    procedure SaveHTMLEmailToInbox(EmailSubject: Text;EmailBodyHTML: Text;SenderAddress: Text;SenderName: Text;RecipientAddress: Text)
    begin
        Service.SaveHtmlMessageToInbox(EmailSubject,EmailBodyHTML,SenderAddress,SenderName,RecipientAddress);
    end;


    procedure GetEmailFolder(FolderId: Text;var Folder: dotnet IEmailFolder): Boolean
    begin
        Folder := Service.GetEmailFolder(FolderId);
        exit(not IsNull(Folder));
    end;


    procedure IdenticalMailExists(SampleMessage: dotnet IEmailMessage;TargetFolder: dotnet IEmailFolder;var TargetMessage: dotnet IEmailMessage): Boolean
    var
        FindResults: dotnet IFindEmailsResults;
        Enumerator: dotnet IEnumerator;
        FolderOffset: Integer;
    begin
        TargetFolder.UseSampleEmailAsFilter(SampleMessage);
        FolderOffset := 0;
        repeat
          FindResults := TargetFolder.FindEmailMessages(50,FolderOffset);
          if FindResults.TotalCount > 0 then begin
            Enumerator := FindResults.GetEnumerator;
            while Enumerator.MoveNext do begin
              TargetMessage := Enumerator.Current;
              if SampleMessage.Subject = TargetMessage.Subject then
                if SampleMessage.Body = TargetMessage.Body then begin
                  if CompareEmailAttachments(SampleMessage,TargetMessage) then
                    exit(true);
                end;
            end;
            FolderOffset := FindResults.NextPageOffset;
          end;
        until not FindResults.MoreAvailable;

        exit(false);
    end;

    local procedure CompareEmailAttachments(LeftMsg: dotnet IEmailMessage;RightMsg: dotnet IEmailMessage): Boolean
    var
        LeftEnum: dotnet IEnumerator;
        RightEnum: dotnet IEnumerator;
        LeftAttrib: dotnet IAttachment;
        RightAttrib: dotnet IAttachment;
        LeftFlag: Boolean;
        RightFlag: Boolean;
    begin
        LeftEnum := LeftMsg.Attachments.GetEnumerator;
        RightEnum := RightMsg.Attachments.GetEnumerator;

        LeftFlag := LeftEnum.MoveNext;
        RightFlag := RightEnum.MoveNext;
        while LeftFlag and RightFlag do begin
          LeftAttrib := LeftEnum.Current;
          RightAttrib := RightEnum.Current;
          if (LeftAttrib.ContentId <> RightAttrib.ContentId) or (LeftAttrib.ContentType <> RightAttrib.ContentType) then
            exit(false);

          LeftFlag := LeftEnum.MoveNext;
          RightFlag := RightEnum.MoveNext;
        end;

        exit(LeftFlag = RightFlag);
    end;

    [TryFunction]
    local procedure TryGetEmailWithAttachments(var EmailMessage: dotnet IEmailMessage;ItemID: Text[250])
    begin
        EmailMessage := Service.GetEmailWithAttachments(ItemID);
    end;


    procedure GetEmailAndAttachments(ItemID: Text[250];var TempExchangeObject: Record "Exchange Object" temporary;"Action": Option InitiateSendToOCR,InitiateSendToIncomingDocuments,InitiateSendToWorkFlow;VendorNumber: Code[20])
    var
        EmailMessage: dotnet IEmailMessage;
        Attachments: dotnet IEnumerable;
        Attachment: dotnet IAttachment;
    begin
        if TryGetEmailWithAttachments(EmailMessage,ItemID) then begin
          if not IsNull(EmailMessage) then
            with TempExchangeObject do begin
              Init;
              Validate("Item ID",EmailMessage.Id);
              Validate(Type,Type::Email);
              Validate(Name,EmailMessage.Subject);
              Validate(Owner,UserSecurityId);
              SetBody(EmailMessage.TextBody);
              SetContent(EmailMessage.Content);
              SetViewLink(EmailMessage.LinkUrl);
              if not Insert(true) then
                Modify(true);

              Attachments := EmailMessage.Attachments;
              foreach Attachment in Attachments do begin
                Init;
                Validate(Type,Type::Attachment);
                Validate("Item ID",Attachment.Id);
                Validate(Name,Attachment.Name);
                Validate("Parent ID",EmailMessage.Id);
                Validate("Content Type",Attachment.ContentType);
                Validate(InitiatedAction,Action);
                Validate(VendorNo,VendorNumber);
                Validate(IsInline,Attachment.IsInline);
                SetContent(Attachment.Content);
                if not Insert(true) then
                  Modify(true);
              end;
            end else
            Error(ExpiredTokenErr)
        end else
          Error(ExpiredTokenErr)
    end;

    [TryFunction]
    local procedure TryEmailHasAttachments(var HasAttachments: Boolean;ItemID: Text[250])
    begin
        HasAttachments := Service.AttachmentsExists(ItemID);
    end;


    procedure EmailHasAttachments(ItemID: Text[250]): Boolean
    var
        HasAttachments: Boolean;
    begin
        if not TryEmailHasAttachments(HasAttachments,ItemID) then
          exit(false);
        exit(HasAttachments)
    end;


    procedure GetEndpoint() Endpoint: Text
    begin
        if IsPPE then
          Endpoint := PPEEndpoint
        else
          Endpoint := ProdEndpoint;
    end;


    procedure IsPPE(): Boolean
    var
        Url: Text[250];
    begin
        Url := Lowercase(GetUrl(Clienttype::Web));
        exit((StrPos(Url,'projectmadeira-test') <> 0) or (StrPos(Url,'projectmadeira-ppe') <> 0) or
          (StrPos(Url,'financials.dynamics-tie.com') <> 0) or (StrPos(Url,'financials.dynamics-ppe.com') <> 0))
    end;


    procedure PPEEndpoint(): Text
    begin
        exit(PPEEndpointTxt);
    end;


    procedure ProdEndpoint(): Text
    begin
        exit(ProdEndpointTxt);
    end;

    [TryFunction]
    local procedure ValidEndpoint()
    begin
        Service.AttachmentsExists(TestMessageIdTxt);
    end;


    procedure GetCurrentUserTimeZone(): Text
    begin
        exit(Service.GetExchangeUserTimeZone);
    end;
}

