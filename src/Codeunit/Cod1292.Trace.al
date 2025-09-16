#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1292 Trace
{

    trigger OnRun()
    begin
    end;

    var
        TraceLogInStream: InStream;
        TraceStreamLogAlreadyInUseErr: label 'Debug stream logging is already in use.';


    procedure LogStreamToTempFile(var ToLogInStream: InStream;Name: Text;var TraceLogTempBlob: Record TempBlob) Filename: Text
    var
        FileManagement: Codeunit "File Management";
        OutStream: OutStream;
    begin
        TraceLogTempBlob.CalcFields(Blob);
        if TraceLogTempBlob.Blob.Hasvalue then
          if not TraceLogInStream.eos then
            Error(TraceStreamLogAlreadyInUseErr);

        TraceLogTempBlob.Blob.CreateOutstream(OutStream);
        CopyStream(OutStream,ToLogInStream);

        Filename := FileManagement.ServerTempFileName(Name + '.XML');

        TraceLogTempBlob.Blob.Export(Filename);

        TraceLogTempBlob.Blob.CreateInstream(TraceLogInStream);
        ToLogInStream := TraceLogInStream;
    end;


    procedure LogXmlDocToTempFile(var XmlDoc: dotnet XmlDocument;Name: Text) Filename: Text
    var
        FileManagement: Codeunit "File Management";
    begin
        Filename := FileManagement.ServerTempFileName(Name + '.XML');
        XmlDoc.Save(Filename);
    end;
}

