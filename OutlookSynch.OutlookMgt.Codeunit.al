#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5304 "Outlook Synch. Outlook Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        OSynchUserSetup: Record "Outlook Synch. User Setup";
        ErrorConflictBuffer: Record "Outlook Synch. Link" temporary;
        OSynchNAVMgt: Codeunit "Outlook Synch. NAV Mgt";
        OSynchTypeConversion: Codeunit "Outlook Synch. Type Conv";
        OSynchProcessLine: Codeunit "Outlook Synch. Process Line";
        ErrorLogXMLWriter: dotnet XmlTextWriter;
        Text001: label 'The synchronization has failed because the synchronization data from Microsoft Outlook cannot be processed. Try again later and if the problem persists contact your system administrator.';
        Encoding: dotnet Encoding;
        EntityRecID: RecordID;
        OSynchActionType: Option Insert,Modify,Delete,Undefined;
        Text002: label 'The %1 entity cannot be synchronized because it is now based on another table. Try again later and if the problem persists contact your system administrator.';
        Text003: label 'The Outlook item for the %1 entity cannot be synchronized because it was not found in Outlook synchronization folders.';
        Text004: label 'The %1 entity does not exist. Try again later and if the problem persists contact your system administrator.';
        StartDateTime: DateTime;
        RootIterator: Text[38];


    procedure ProcessOutlookChanges(UserID: Code[50];XMLMessage: Text;var XMLTextWriterIn: dotnet XmlTextWriter;SkipCheckForConflicts: Boolean) StartSynchTime: DateTime
    var
        OSynchEntity: Record "Outlook Synch. Entity";
        OSynchLink: Record "Outlook Synch. Link";
        AllObjWithCaption: Record AllObjWithCaption;
        XMLTextReader: dotnet XmlTextReader;
        Container: Text;
        SynchEntityCode: Code[10];
        TagName: Text[80];
        EntryIDHash: Text[32];
        StartSynchTimeText: Text[30];
        ProcessingFailed: Boolean;
    begin
        XMLTextReader := XMLTextReader.XmlTextReader;
        if not XMLTextReader.LoadXml(XMLMessage) then
          Error(Text001);

        ErrorLogXMLWriter := XMLTextWriterIn;

        OSynchUserSetup.Reset;
        OSynchUserSetup.SetRange("User ID",UserID);
        if not OSynchUserSetup.FindFirst then
          exit;

        if IsNull(XMLTextReader) then
          Error(Text001);

        TagName := XMLTextReader.RootLocalName;
        if TagName <> 'SynchronizationMessage' then
          Error(Text001);

        XMLTextReader.SelectElements(RootIterator,'SynchronizationMessage');
        StartSynchTimeText := XMLTextReader.GetCurrentNodeAttribute(RootIterator,'StartSynchTime');
        if not OSynchTypeConversion.TextToDateTime(StartSynchTimeText,StartSynchTime) then
          Error(Text001);

        StartDateTime := StartSynchTime;

        if XMLTextReader.SelectElements(RootIterator,'*') < 1 then
          exit;

        TagName := XMLTextReader.GetName(RootIterator);
        if not ((TagName <> 'OutlookItem') or (TagName <> 'DeletedOutlookItem')) then
          Error(Text001);

        if XMLTextReader.SelectElements(RootIterator,'child::OutlookItem | child::DeletedOutlookItem') > 0
        then begin
          Clear(Container);
          repeat
            Clear(EntityRecID);
            Clear(OSynchProcessLine);
            OSynchActionType := Osynchactiontype::Undefined;
            EntryIDHash := '';

            TagName := XMLTextReader.GetName(RootIterator);
            SynchEntityCode :=
              CopyStr(XMLTextReader.GetCurrentNodeAttribute(RootIterator,'SynchEntityCode'),1,MaxStrLen(SynchEntityCode));
            if OSynchUserSetup.Get(UserID,SynchEntityCode) then
              if (OSynchUserSetup."Synch. Direction" <> OSynchUserSetup."synch. direction"::"Microsoft Dynamics NAV to Outlook") and
                 OSynchEntity.Get(SynchEntityCode)
              then begin
                EntryIDHash := GetEntryIDHash(Container,XMLTextReader,RootIterator);
                if EntryIDHash <> '' then begin
                  OSynchLink.Reset;
                  OSynchLink.SetRange("User ID",UserID);
                  OSynchLink.SetRange("Outlook Entry ID Hash",EntryIDHash);
                  if OSynchLink.FindFirst then begin
                    Evaluate(EntityRecID,Format(OSynchLink."Record ID"));
                    if TagName = 'OutlookItem' then begin
                      if EntityRecID.TableNo <> OSynchEntity."Table No." then begin
                        AllObjWithCaption.Get(AllObjWithCaption."object type"::Table,EntityRecID.TableNo);
                        WriteErrorLog(
                          OSynchUserSetup."User ID",
                          EntityRecID,
                          'Error',
                          SynchEntityCode,
                          StrSubstNo(Text002,SynchEntityCode),
                          ErrorLogXMLWriter,
                          Container);
                      end else
                        OSynchActionType := Osynchactiontype::Modify;
                    end;
                    if TagName = 'DeletedOutlookItem' then
                      OSynchActionType := Osynchactiontype::Delete;
                  end else
                    if TagName = 'OutlookItem' then
                      OSynchActionType := Osynchactiontype::Insert;

                  if OSynchActionType <> Osynchactiontype::Undefined then begin
                    Clear(OSynchProcessLine);
                    OSynchProcessLine.SetGlobalParameters(
                      OSynchEntity,
                      OSynchUserSetup,
                      ErrorConflictBuffer,
                      XMLTextReader,
                      ErrorLogXMLWriter,
                      RootIterator,
                      OSynchActionType,
                      Format(EntityRecID),
                      Container,
                      EntryIDHash,
                      StartDateTime,
                      SkipCheckForConflicts);

                    Commit;
                    if not OSynchProcessLine.Run then begin
                      if GetLastErrorText <> '' then
                        WriteErrorLog(
                          OSynchUserSetup."User ID",
                          EntityRecID,
                          'Error',
                          SynchEntityCode,
                          GetLastErrorText,
                          ErrorLogXMLWriter,
                          Container);
                      ClearLastError;
                      ErrorConflictBuffer.Reset;
                      ErrorConflictBuffer.Init;
                      ErrorConflictBuffer."User ID" := UserID;
                      ErrorConflictBuffer."Record ID" := EntityRecID;
                      ErrorConflictBuffer."Search Record ID" := Format(EntityRecID);
                      if ErrorConflictBuffer.Insert then;
                    end;
                  end;
                end else
                  WriteErrorLog(
                    OSynchUserSetup."User ID",
                    EntityRecID,
                    'Error',
                    SynchEntityCode,
                    StrSubstNo(Text003,SynchEntityCode),
                    ErrorLogXMLWriter,
                    Container);
              end else begin
                WriteErrorLog(
                  OSynchUserSetup."User ID",
                  EntityRecID,
                  'Error',
                  SynchEntityCode,
                  StrSubstNo(Text004,SynchEntityCode),
                  ErrorLogXMLWriter,
                  Container);
                ProcessingFailed := true;
              end;
          until not XMLTextReader.MoveNext(RootIterator) or ProcessingFailed;
        end;

        XMLTextReader.RemoveIterator(RootIterator);
        Clear(XMLTextReader);
    end;


    procedure GetEntryIDHash(var Container: Text;var XMLTextReaderIn: dotnet XmlTextReader;RootIteratorIn: Text[38]) EntryIDHash: Text[32]
    var
        TmpIterator: Text[38];
    begin
        if XMLTextReaderIn.GetAllCurrentChildNodes(RootIteratorIn,TmpIterator) > 0 then
          if XMLTextReaderIn.GetName(TmpIterator) = 'EntryID' then begin
            Container := ConvertValueFromBase64(XMLTextReaderIn.GetValue(TmpIterator));
            EntryIDHash := ComputeHash(Container);
            XMLTextReaderIn.RemoveIterator(TmpIterator);
          end;
    end;


    procedure WriteErrorLog(UserID: Code[50];ErrorRecordID: RecordID;KindOfProblem: Text[80];SynchEntityCode: Code[10];Description: Text[1024];var ErrorLogXMLWriter1: dotnet XmlTextWriter;Container: Text)
    begin
        ErrorLogXMLWriter1.WriteStartElement(KindOfProblem);
        ErrorLogXMLWriter1.WriteAttribute('SynchEntityCode',SynchEntityCode);
        ErrorLogXMLWriter1.WriteAttribute('RecordID',Format(ErrorRecordID));

        ErrorLogXMLWriter1.WriteAttribute(
          'OccurrenceTime',
          OSynchTypeConversion.SetDateTimeFormat(
            OSynchTypeConversion.LocalDT2UTC(CurrentDatetime)));

        if (KindOfProblem = 'Conflict') and (Format(ErrorRecordID) <> '') then
          ErrorLogXMLWriter1.WriteAttribute(
            'LastModificationTime',
            OSynchTypeConversion.SetDateTimeFormat(
              OSynchTypeConversion.LocalDT2UTC(GetLastModificationTime(ErrorRecordID))));
        ErrorLogXMLWriter1.WriteAttribute('Description',Description);

        if Format(ErrorRecordID) = '' then begin
          ErrorLogXMLWriter1.WriteStartElement('EntryID');
          ErrorLogXMLWriter1.WriteElementTextContent(ConvertValueToBase64(Container));
          ErrorLogXMLWriter1.WriteEndElement;
        end else
          OSynchNAVMgt.WriteLinkedOutlookEntryID(UserID,ErrorRecordID,ErrorLogXMLWriter1);

        ErrorLogXMLWriter1.WriteEndElement;
    end;


    procedure GetLastModificationTime(SynchRecordID: RecordID) LastModificationTime: DateTime
    var
        ChangeLogEntry: Record "Change Log Entry";
        SynchRecRef: RecordRef;
        RecID: RecordID;
        IsDeleted: Boolean;
    begin
        LastModificationTime := 0DT;

        IsDeleted := not SynchRecRef.Get(SynchRecordID);
        if IsDeleted then
          SynchRecRef := SynchRecordID.GetRecord;
        Evaluate(RecID,Format(SynchRecRef.RecordId));

        ChangeLogEntry.SetCurrentkey("Table No.","Primary Key Field 1 Value");
        OSynchProcessLine.FilterChangeLog(RecID,ChangeLogEntry);
        if IsDeleted then
          ChangeLogEntry.SetRange("Type of Change",ChangeLogEntry."type of change"::Deletion)
        else
          ChangeLogEntry.SetFilter("Type of Change",'<>%1',ChangeLogEntry."type of change"::Deletion);
        if ChangeLogEntry.FindLast then
          LastModificationTime := ChangeLogEntry."Date and Time";
    end;


    procedure ComputeHash(stringToHash: Text) hashValue: Text[32]
    var
        HashAlgorithm: dotnet HashAlgorithm;
        Convert: dotnet Convert;
    begin
        if stringToHash = '' then
          exit('');

        HashAlgorithm := HashAlgorithm.Create;
        hashValue := Convert.ToBase64String(HashAlgorithm.ComputeHash(Encoding.UTF8.GetBytes(Lowercase(stringToHash))));
        Clear(HashAlgorithm);
        exit(hashValue);
    end;


    procedure ConvertValueFromBase64(base64Value: Text) stringValue: Text
    var
        Convert: dotnet Convert;
    begin
        if base64Value = '' then
          exit('');

        stringValue := Encoding.UTF8.GetString(Convert.FromBase64String(base64Value));
        exit(stringValue);
    end;


    procedure ConvertValueToBase64(stringValue: Text) base64Value: Text
    var
        Convert: dotnet Convert;
    begin
        if stringValue = '' then
          exit('');

        base64Value := Convert.ToBase64String(Encoding.UTF8.GetBytes(stringValue));
        exit(base64Value);
    end;
}

