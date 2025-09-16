#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5310 "Outlook Synch. Resolve Confl."
{

    trigger OnRun()
    begin
    end;

    var
        Text001: label 'The synchronization failed because the synchronization data from Microsoft Outlook cannot be processed. Try again later and if the problem persists contact your system administrator.';
        Text002: label 'The synchronization failed because the synchronization data from %1 could not be sent. Try again later and if the problem persists contact your system administrator.', Comment='%1 - product name';


    procedure Process(UserID: Code[50];var XMLMessage: Text)
    var
        OsynchOutlookMgt: Codeunit "Outlook Synch. Outlook Mgt.";
        ErrorLogXMLWriter: dotnet XmlTextWriter;
    begin
        if not (StrLen(XMLMessage) > 0) then
          Error(Text001);

        ErrorLogXMLWriter := ErrorLogXMLWriter.XmlTextWriter;
        ErrorLogXMLWriter.WriteStartDocument;
        ErrorLogXMLWriter.WriteStartElement('SynchronizationMessage');

        OsynchOutlookMgt.ProcessOutlookChanges(UserID,XMLMessage,ErrorLogXMLWriter,true);

        if not IsNull(ErrorLogXMLWriter) then begin
          ErrorLogXMLWriter.WriteEndElement;
          ErrorLogXMLWriter.WriteEndDocument;

          XMLMessage := ErrorLogXMLWriter.ToString;
          Clear(ErrorLogXMLWriter);

          if StrLen(XMLMessage) = 0 then
            Error(Text002,ProductName.Full);
        end;
    end;
}

