#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5064 "Email Logging Dispatcher"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        MarketingSetup: Record "Marketing Setup";
        StorageFolder: dotnet IEmailFolder;
        QueueFolder: dotnet IEmailFolder;
        WebCredentials: dotnet WebCredentials;
    begin
        if IsNullGuid(ID) then
          exit;

        SetErrorContext(Text101);
        CheckSetup(MarketingSetup);

        SetErrorContext(Text102);
        if MarketingSetup."Exchange Account User Name" <> '' then
          MarketingSetup.CreateExchangeAccountCredentials(WebCredentials);

        if not ExchangeWebServicesServer.Initialize(MarketingSetup."Autodiscovery E-Mail Address",
             MarketingSetup."Exchange Service URL",WebCredentials,true)
        then
          Error(Text001);

        SetErrorContext(Text103);
        if not ExchangeWebServicesServer.GetEmailFolder(MarketingSetup.GetQueueFolderUID,QueueFolder) then
          Error(Text002,MarketingSetup."Queue Folder Path");

        SetErrorContext(Text104);
        if not ExchangeWebServicesServer.GetEmailFolder(MarketingSetup.GetStorageFolderUID,StorageFolder) then
          Error(Text002,MarketingSetup."Storage Folder Path");

        RunEMailBatch(MarketingSetup."Email Batch Size",QueueFolder,StorageFolder);
    end;

    var
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
        Text001: label 'Autodiscovery of exchange service failed.';
        Text002: label 'The %1 folder does not exist. Verify that the path to the folder is correct in the Marketing Setup window.';
        Text003: label 'The queue or storage folder has not been initialized. Enter the folder path in the Marketing Setup window.';
        Text101: label 'Validating setup';
        Text102: label 'Initialization and autodiscovery of Exchange web service is in progress';
        Text103: label 'Opening queue folder';
        Text104: label 'Opening storage folder';
        Text105: label 'Reading email messages';
        Text106: label 'Checking next email message';
        Text107: label 'Logging email messages';
        Text108: label 'Deleting email message from queue';
        ErrorContext: Text;
        Text109: label 'The interaction template for email messages has not been specified in the Interaction Template Setup window.';
        Text110: label 'An interaction template for email messages has been specified in the Interaction Template Setup window, but the template does not exist.';


    procedure CheckSetup(var MarketingSetup: Record "Marketing Setup")
    var
        ErrorMsg: Text;
    begin
        if not CheckInteractionTemplateSetup(ErrorMsg) then
          Error(ErrorMsg);

        MarketingSetup.Get;
        if not (MarketingSetup."Queue Folder UID".Hasvalue and MarketingSetup."Storage Folder UID".Hasvalue) then
          Error(Text003);

        MarketingSetup.TestField("Autodiscovery E-Mail Address");
    end;


    procedure RunEMailBatch(BatchSize: Integer;var QueueFolder: dotnet IEmailFolder;var StorageFolder: dotnet IEmailFolder)
    var
        QueueFindResults: dotnet IFindEmailsResults;
        QueueEnumerator: dotnet IEnumerator;
        QueueMessage: dotnet IEmailMessage;
        EmailsLeftInBatch: Integer;
        PageSize: Integer;
    begin
        EmailsLeftInBatch := BatchSize;
        repeat
          SetErrorContext(Text105);

          PageSize := 50;
          if (BatchSize <> 0) and (EmailsLeftInBatch < PageSize) then
            PageSize := EmailsLeftInBatch;

          // Keep using zero offset, since all processed messages are deleted from the queue folder
          QueueFindResults := QueueFolder.FindEmailMessages(PageSize,0);
          QueueEnumerator := QueueFindResults.GetEnumerator;
          while QueueEnumerator.MoveNext do begin
            QueueMessage := QueueEnumerator.Current;
            ProcessMessage(QueueMessage,StorageFolder);
            SetErrorContext(Text108);
            QueueMessage.Delete;
          end;

          EmailsLeftInBatch := EmailsLeftInBatch - PageSize;
        until (not QueueFindResults.MoreAvailable) or ((BatchSize <> 0) and (EmailsLeftInBatch <= 0));
    end;


    procedure GetErrorContext(): Text
    begin
        exit(ErrorContext);
    end;


    procedure SetErrorContext(NewContext: Text)
    begin
        ErrorContext := NewContext;
    end;


    procedure ItemLinkedFromAttachment(MessageId: Text;var Attachment: Record Attachment): Boolean
    begin
        Attachment.SetRange("Email Message Checksum",Attachment.Checksum(MessageId));

        if not Attachment.FindSet then
          exit(false);
        repeat
          if Attachment.GetMessageID = MessageId then
            exit(true);
        until (Attachment.Next = 0);
        exit(false);
    end;


    procedure AttachmentRecordAlreadyExists(AttachmentNo: Text;var Attachment: Record Attachment): Boolean
    var
        No: Integer;
    begin
        if Evaluate(No,AttachmentNo) then
          exit(Attachment.Get(No));
        exit(false);
    end;

    local procedure SalespersonRecipients(Message: dotnet IEmailMessage;var SegLine: Record "Segment Line"): Boolean
    var
        RecepientEnumerator: dotnet IEnumerator;
        Recepient: dotnet IEmailAddress;
        RecepientAddress: Text;
    begin
        RecepientEnumerator := Message.Recipients.GetEnumerator;
        while RecepientEnumerator.MoveNext do begin
          Recepient := RecepientEnumerator.Current;
          RecepientAddress := Recepient.Address;
          if IsSalesperson(RecepientAddress,SegLine."Salesperson Code") then begin
            SegLine.Insert;
            SegLine."Line No." := SegLine."Line No." + 1;
          end;
        end;
        exit(not SegLine.IsEmpty);
    end;

    local procedure ContactRecipients(Message: dotnet IEmailMessage;var SegLine: Record "Segment Line"): Boolean
    var
        RecepientEnumerator: dotnet IEnumerator;
        RecepientAddress: dotnet IEmailAddress;
    begin
        RecepientEnumerator := Message.Recipients.GetEnumerator;
        while RecepientEnumerator.MoveNext do begin
          RecepientAddress := RecepientEnumerator.Current;
          if IsContact(RecepientAddress.Address,SegLine) then begin
            SegLine.Insert;
            SegLine."Line No." := SegLine."Line No." + 1;
          end;
        end;
        exit(not SegLine.IsEmpty);
    end;

    local procedure IsMessageToLog(QueueMessage: dotnet IEmailMessage;StorageFolder: dotnet IEmailFolder;var SegLine: Record "Segment Line";var Attachment: Record Attachment): Boolean
    var
        StorageMessage: dotnet IEmailMessage;
        Sender: dotnet IEmailAddress;
        SenderAddress: Text;
        MessageId: Text;
    begin
        if QueueMessage.IsSensitive then
          exit(false);

        Sender := QueueMessage.SenderAddress;
        if Sender.IsEmpty or (QueueMessage.RecipientsCount = 0) then
          exit(false);

        if ExchangeWebServicesServer.IdenticalMailExists(QueueMessage,StorageFolder,StorageMessage) then begin
          MessageId := StorageMessage.Id;
          StorageMessage.Delete;
          if ItemLinkedFromAttachment(MessageId,Attachment) then
            exit(true);
        end;

        if AttachmentRecordAlreadyExists(QueueMessage.NavAttachmentNo,Attachment) then
          exit(true);

        // Check if in- or out-bound and store sender and recipients in segment line(s)
        SenderAddress := Sender.Address;
        if IsSalesperson(SenderAddress,SegLine."Salesperson Code") then begin
          SegLine."Information Flow" := SegLine."information flow"::Outbound;
          if not ContactRecipients(QueueMessage,SegLine) then
            exit(false);
        end else begin
          if IsContact(SenderAddress,SegLine) then begin
            SegLine."Information Flow" := SegLine."information flow"::Inbound;
            if not SalespersonRecipients(QueueMessage,SegLine) then
              exit(false);
          end else
            exit(false);
        end;

        exit(not SegLine.IsEmpty);
    end;


    procedure UpdateSegLine(var SegLine: Record "Segment Line";Emails: Code[10];Subject: Text;DateSent: dotnet DateTime;DateReceived: dotnet DateTime;AttachmentNo: Integer)
    var
        LineDate: dotnet DateTime;
        DateTimeKind: dotnet DateTimeKind;
        InformationFlow: Integer;
    begin
        InformationFlow := SegLine."Information Flow";
        SegLine.Validate("Interaction Template Code",Emails);
        SegLine."Information Flow" := InformationFlow;
        SegLine."Correspondence Type" := SegLine."correspondence type"::Email;
        SegLine.Description := CopyStr(Subject,1,MaxStrLen(SegLine.Description));

        if SegLine."Information Flow" = SegLine."information flow"::Outbound then begin
          LineDate := DateSent;
          SegLine."Initiated By" := SegLine."initiated by"::Us;
        end else begin
          LineDate := DateReceived;
          SegLine."Initiated By" := SegLine."initiated by"::Them;
        end;

        // The date received from Exchange is UTC and to record the UTC date and time
        // using the AL functions requires datetime to be of the local date time kind.
        LineDate := LineDate.DateTime(LineDate.Ticks,DateTimeKind.Local);
        SegLine.Date := Dt2Date(LineDate);
        SegLine."Time of Interaction" := Dt2Time(LineDate);

        SegLine.Subject := CopyStr(Subject,1,MaxStrLen(SegLine.Subject));
        SegLine."Attachment No." := AttachmentNo;
        SegLine.Modify;
    end;

    local procedure LogMessageAsInteraction(QueueMessage: dotnet IEmailMessage;StorageFolder: dotnet IEmailFolder;var SegLine: Record "Segment Line";var Attachment: Record Attachment)
    var
        InteractLogEntry: Record "Interaction Log Entry";
        InteractionTemplateSetup: Record "Interaction Template Setup";
        StorageMessage: dotnet IEmailMessage;
        OStream: OutStream;
        Subject: Text;
        EMailMessageUrl: Text;
        AttachmentNo: Integer;
        NextInteractLogEntryNo: Integer;
    begin
        if not SegLine.IsEmpty then begin
          Subject := QueueMessage.Subject;

          Attachment.Reset;
          Attachment.LockTable;
          if Attachment.FindLast then
            AttachmentNo := Attachment."No." + 1
          else
            AttachmentNo := 1;

          Attachment.Init;
          Attachment."No." := AttachmentNo;
          Attachment.Insert;

          InteractionTemplateSetup.Get;
          SegLine.Reset;
          SegLine.FindSet(true);
          repeat
            UpdateSegLine(
              SegLine,InteractionTemplateSetup."E-Mails",Subject,QueueMessage.DateTimeSent,QueueMessage.DateTimeReceived,
              Attachment."No.");
          until SegLine.Next = 0;

          InteractLogEntry.LockTable;
          if InteractLogEntry.FindLast then
            NextInteractLogEntryNo := InteractLogEntry."Entry No.";
          if SegLine.FindSet then
            repeat
              NextInteractLogEntryNo := NextInteractLogEntryNo + 1;
              InsertInteractionLogEntry(SegLine,NextInteractLogEntryNo);
            until SegLine.Next = 0;
        end;

        if Attachment."No." <> 0 then begin
          StorageMessage := QueueMessage.CopyToFolder(StorageFolder);
          Attachment.LinkToMessage(StorageMessage.Id,StorageMessage.EntryId,true);

          StorageMessage.NavAttachmentNo := Format(Attachment."No.");
          StorageMessage.Update;

          Attachment."Email Message Url".CreateOutstream(OStream);
          EMailMessageUrl := StorageMessage.LinkUrl;
          if EMailMessageUrl <> '' then
            OStream.Write(EMailMessageUrl);
          Attachment.Modify;

          Commit;
        end;
    end;


    procedure InsertInteractionLogEntry(SegLine: Record "Segment Line";EntryNo: Integer)
    var
        InteractLogEntry: Record "Interaction Log Entry";
        SegManagement: Codeunit SegManagement;
    begin
        InteractLogEntry.Init;
        InteractLogEntry."Entry No." := EntryNo;
        InteractLogEntry."Correspondence Type" := InteractLogEntry."correspondence type"::Email;
        SegManagement.CopyFieldsToInteractLogEntry(InteractLogEntry,SegLine);
        InteractLogEntry."E-Mail Logged" := true;
        InteractLogEntry.Insert;
    end;


    procedure IsSalesperson(Email: Text;var SalespersonCode: Code[10]): Boolean
    var
        Salesperson: Record "Salesperson/Purchaser";
    begin
        if Email = '' then
          exit(false);

        if StrLen(Email) > MaxStrLen(Salesperson."Search E-Mail") then
          exit(false);

        Salesperson.SetCurrentkey("Search E-Mail");
        Salesperson.SetRange("Search E-Mail",Email);
        if Salesperson.FindFirst then begin
          SalespersonCode := Salesperson.Code;
          exit(true);
        end;
        exit(false);
    end;


    procedure IsContact(EMail: Text;var SegLine: Record "Segment Line"): Boolean
    var
        Cont: Record Contact;
        ContAltAddress: Record "Contact Alt. Address";
    begin
        if EMail = '' then
          exit(false);

        if StrLen(EMail) > MaxStrLen(Cont."Search E-Mail") then
          exit(false);

        Cont.SetCurrentkey("Search E-Mail");
        Cont.SetRange("Search E-Mail",EMail);
        if Cont.FindFirst then begin
          SegLine."Contact No." := Cont."No.";
          SegLine."Contact Company No." := Cont."Company No.";
          SegLine."Contact Alt. Address Code" := '';
          exit(true);
        end;

        if StrLen(EMail) > MaxStrLen(ContAltAddress."Search E-Mail") then
          exit(false);

        ContAltAddress.SetCurrentkey("Search E-Mail");
        ContAltAddress.SetRange("Search E-Mail",EMail);
        if ContAltAddress.FindFirst then begin
          SegLine."Contact No." := ContAltAddress."Contact No.";
          Cont.Get(ContAltAddress."Contact No.");
          SegLine."Contact Company No." := Cont."Company No.";
          SegLine."Contact Alt. Address Code" := ContAltAddress.Code;
          exit(true);
        end;

        exit(false);
    end;

    local procedure ProcessMessage(QueueMessage: dotnet IEmailMessage;StorageFolder: dotnet IEmailFolder)
    var
        TempSegLine: Record "Segment Line" temporary;
        Attachment: Record Attachment;
    begin
        TempSegLine.DeleteAll;
        TempSegLine.Init;

        Attachment.Init;
        Attachment.Reset;

        SetErrorContext(Text106);
        if IsMessageToLog(QueueMessage,StorageFolder,TempSegLine,Attachment) then begin
          SetErrorContext(Text107);
          LogMessageAsInteraction(QueueMessage,StorageFolder,TempSegLine,Attachment);
        end;
    end;


    procedure CheckInteractionTemplateSetup(var ErrorMsg: Text): Boolean
    var
        InteractionTemplateSetup: Record "Interaction Template Setup";
        InteractionTemplate: Record "Interaction Template";
    begin
        // Emails cannot be automatically logged unless the field Emails on Interaction Template Setup is set.
        InteractionTemplateSetup.Get;
        if InteractionTemplateSetup."E-Mails" = '' then begin
          ErrorMsg := Text109;
          exit(false);
        end;

        // Since we have no guarantees that the Interaction Template for Emails exists, we check for it here.
        InteractionTemplate.SetFilter(Code,'=%1',InteractionTemplateSetup."E-Mails");
        if not InteractionTemplate.FindFirst then begin
          ErrorMsg := Text110;
          exit(false);
        end;

        exit(true);
    end;
}

