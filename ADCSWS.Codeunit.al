#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7714 "ADCS WS"
{

    trigger OnRun()
    begin
    end;

    var
        ADCSManagement: Codeunit "ADCS Management";


    procedure ProcessDocument(var Document: Text)
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        InputXmlDocument: dotnet XmlDocument;
        OutputXmlDocument: dotnet XmlDocument;
    begin
        XMLDOMManagement.LoadXMLDocumentFromText(Document,InputXmlDocument);
        ADCSManagement.ProcessDocument(InputXmlDocument);
        ADCSManagement.GetOutboundDocument(OutputXmlDocument);
        Document := OutputXmlDocument.OuterXml;
    end;
}

