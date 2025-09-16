#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1237 "Get Json Structure"
{

    trigger OnRun()
    begin
    end;

    var
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        JsonConvert: dotnet JsonConvert;
        GLBHttpStatusCode: dotnet HttpStatusCode;
        GLBResponseHeaders: dotnet NameValueCollection;
        FileContent: Text;
        InvalidResponseErr: label 'The response was not valid.';


    procedure GenerateStructure(Path: Text;var XMLBuffer: Record "XML Buffer")
    var
        TempBlob: Record TempBlob;
        ResponseTempBlob: Record TempBlob;
        XMLBufferWriter: Codeunit "XML Buffer Writer";
        JsonInStream: InStream;
        XMLOutStream: OutStream;
        File: File;
    begin
        if File.Open(Path) then
          File.CreateInstream(JsonInStream)
        else begin
          Clear(ResponseTempBlob);
          ResponseTempBlob.Init;
          ResponseTempBlob.Blob.CreateInstream(JsonInStream);
          Clear(HttpWebRequestMgt);
          HttpWebRequestMgt.Initialize(Path);
          HttpWebRequestMgt.SetMethod('POST');
          HttpWebRequestMgt.SetReturnType('application/json');
          HttpWebRequestMgt.SetContentType('application/x-www-form-urlencoded');
          HttpWebRequestMgt.AddHeader('Accept-Encoding','utf-8');
          HttpWebRequestMgt.GetResponse(JsonInStream,GLBHttpStatusCode,GLBResponseHeaders);
        end;

        TempBlob.Init;
        TempBlob.Blob.CreateOutstream(XMLOutStream);
        if not JsonToXML(JsonInStream,XMLOutStream) then
          if not JsonToXMLCreateDefaultRoot(JsonInStream,XMLOutStream) then
            Error(InvalidResponseErr);

        XMLBufferWriter.GenerateStructure(XMLBuffer,XMLOutStream);
    end;

    [TryFunction]

    procedure JsonToXML(JsonInStream: InStream;var XMLOutStream: OutStream)
    var
        XmlDocument: dotnet XmlDocument;
        NewContent: Text;
    begin
        while JsonInStream.Read(NewContent) > 0 do
          FileContent += NewContent;

        XmlDocument := JsonConvert.DeserializeXmlNode(FileContent);
        XmlDocument.Save(XMLOutStream);
    end;

    [TryFunction]

    procedure JsonToXMLCreateDefaultRoot(JsonInStream: InStream;var XMLOutStream: OutStream)
    var
        XmlDocument: dotnet XmlDocument;
        NewContent: Text;
    begin
        while JsonInStream.Read(NewContent) > 0 do
          FileContent += NewContent;

        FileContent := '{"root":' + FileContent + '}';

        XmlDocument := JsonConvert.DeserializeXNode(FileContent,'root');
        XmlDocument.Save(XMLOutStream);
    end;
}

